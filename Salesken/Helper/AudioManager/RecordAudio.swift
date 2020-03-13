//
//  RecordAudio.swift
//  Salesken
//
//  Created by Anup on 11/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import Foundation
import AVFoundation
import AudioUnit

final class RecordAudio: NSObject {
    
    var auAudioUnit: AUAudioUnit! = nil
    
    var enableRecording     = true
    var audioSessionActive  = false
    var audioSetupComplete  = false
    var isRecording         = false
    
    var sampleRate : Double =  48000.0      // desired audio sample rate
    
    let circBuffSize        =  32768        // lock-free circular fifo/buffer size
    var circBuffer          = [Float](repeating: 0, count: 32768)
    var circInIdx  : Int    =  0            // sample input  index
    var circOutIdx : Int    =  0            // sample output index
    
    var audioLevel : Float  = 0.0
    
    private var micPermissionRequested  = false
    private var micPermissionGranted    = false
    
    // for restart from audio interruption notification
    private var audioInterrupted        = false
    
    private var renderBlock : AURenderBlock? = nil
    
    func startRecording() {
        
        if isRecording { return }
        
        if audioSessionActive == false {
            // configure and activate Audio Session, this might change the sampleRate
            setupAudioSessionForRecording()
        }
        
        guard micPermissionGranted && audioSessionActive else { return }
        
        let audioFormat = AVAudioFormat(
            commonFormat: AVAudioCommonFormat.pcmFormatInt16,   // pcmFormatInt16, pcmFormatFloat32,
            sampleRate: Double(sampleRate),                     // 44100.0 48000.0
            channels:AVAudioChannelCount(2),                    // 1 or 2
            interleaved: false )                                 // true for interleaved stereo
        
        if (auAudioUnit == nil) {
            setupRemoteIOAudioUnitForRecord(audioFormat: audioFormat!)
        }
        
        renderBlock = auAudioUnit.renderBlock  //  returns AURenderBlock()
        
        if (   enableRecording
            && micPermissionGranted
            && audioSetupComplete
            && audioSessionActive
            && isRecording == false ) {
            
            auAudioUnit.isInputEnabled  = true
            
            auAudioUnit.outputProvider = { // AURenderPullInputBlock()
                
                (actionFlags, timestamp, frameCount, inputBusNumber, inputData) -> AUAudioUnitStatus in
                
                if let block = self.renderBlock {       // AURenderBlock?
                    let err : OSStatus = block(actionFlags,
                                               timestamp,
                                               frameCount,
                                               1,
                                               inputData,
                                               .none)
                    if err == noErr {
                        // save samples from current input buffer to circular buffer
                        
                        self.recordMicrophoneInputSamples(
                            inputDataList:  inputData,
                            frameCount: UInt32(frameCount) )
                    }
                }
                let err2 : AUAudioUnitStatus = noErr
                return err2
            }
            
            do {
                circInIdx   =   0                       // initialize circular buffer pointers
                circOutIdx  =   0
                try auAudioUnit.allocateRenderResources()
                try auAudioUnit.startHardware()         // equivalent to AudioOutputUnitStart ???
                isRecording = true
                
            } catch let error{
                print(error)
            }
        }
    }
    
    
    
    func stopRecording() {
        
        if (isRecording) {
            auAudioUnit.stopHardware()
            isRecording = false
        }
        if (audioSessionActive) {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch  let error {
                print(error)
            }
            audioSessionActive = false
        }
    }
    
    func sendToServer(data: Data){
//        if Socket.instance.isConnected{
//            Socket.instance.writeBinary(data: data)
//        }else{
//            print("socket is disconnected")
//        }
        
    }
    
    // process RemoteIO Buffer from mic input
    private func recordMicrophoneInputSamples(inputDataList : UnsafeMutablePointer<AudioBufferList>,frameCount : UInt32 ){
        let inputDataPtr = UnsafeMutableAudioBufferListPointer(inputDataList)
        let mBuffers : AudioBuffer = inputDataPtr[0]
        let count = Int(frameCount)
        
        let bufferPointer = UnsafeMutableRawPointer(mBuffers.mData)
        let data = Data(bytes: mBuffers.mData!, count: Int(mBuffers.mDataByteSize))
        
        //send to websocket
        sendToServer(data: data)
        
        var j = self.circInIdx          // current circular array input index
        let n = self.circBuffSize
        var audioLevelSum : Float = 0.0
        if let bptr = bufferPointer?.assumingMemoryBound(to: Int16.self) {
            for i in 0..<(count/2) {
                // Save samples in circular buffer for latter processing
                let x = Float(bptr[i+i  ])    // microphone
                let y = Float(bptr[i+i+1])     // speaker
                self.circBuffer[j    ] = x // Stereo Left
                self.circBuffer[j + 1] = y // Stereo Right
                j += 2 ; if j >= n { j = 0 }                // Circular buffer looping
                // Microphone Input Analysis
                audioLevelSum += x * x + y * y
                
            }
        }
        OSMemoryBarrier();              // from libkern/OSAtomic.h
        self.circInIdx = j              // circular index will always be less than size
        if audioLevelSum > 0.0 && count > 0 {
            audioLevel = logf(audioLevelSum / Float(count))
        }
    }
    
    // set up and activate Audio Session
    func setupAudioSessionForRecording() {
        do {
            
            let audioSession = AVAudioSession.sharedInstance()
            
            if (micPermissionGranted == false) {
                if (micPermissionRequested == false) {
                    micPermissionRequested = true
                    audioSession.requestRecordPermission({(granted: Bool)-> Void in
                        if granted {
                            self.micPermissionGranted = true
                            self.startRecording()
                            return
                        } else {
                            self.enableRecording = false
                            // dispatch in main/UI thread an alert
                            //   informing that mic permission is not switched on
                        }
                    })
                }
                return
            }
            
            if enableRecording {
                try audioSession.setCategory(AVAudioSession.Category.record)
            }
            let preferredIOBufferDuration = 0.0053  // 5.3 milliseconds = 256 samples
            try audioSession.setPreferredSampleRate(sampleRate) // at 48000.0
            try audioSession.setPreferredIOBufferDuration(preferredIOBufferDuration)
            
            NotificationCenter.default.addObserver(
                forName: AVAudioSession.interruptionNotification,
                object: nil,
                queue: nil,
                using: myAudioSessionInterruptionHandler )
            
            try audioSession.setActive(true)
            audioSessionActive = true
        } catch let error {
            print(error)
        }
    }
    
    // find and set up the sample format for the RemoteIO Audio Unit
    private func setupRemoteIOAudioUnitForRecord(audioFormat : AVAudioFormat) {
        
        do {
            let audioComponentDescription = AudioComponentDescription(
                componentType: kAudioUnitType_Output,
                componentSubType: kAudioUnitSubType_RemoteIO,
                componentManufacturer: kAudioUnitManufacturer_Apple,
                componentFlags: 0,
                componentFlagsMask: 0 )
            
            
            try auAudioUnit = AUAudioUnit(componentDescription: audioComponentDescription)
            
            // bus 1 is for data that the microphone exports out to the handler block
            let bus1 = auAudioUnit.outputBusses[1]
            
            try bus1.setFormat(audioFormat)  //      for microphone bus
            audioSetupComplete = true
        } catch /* let error as NSError */ {
            // placeholder for error handling
        }
    }
    
    private func myAudioSessionInterruptionHandler(notification: Notification) -> Void {
        let interuptionDict = notification.userInfo
        if let interuptionType = interuptionDict?[AVAudioSessionInterruptionTypeKey] {
            let interuptionVal = AVAudioSession.InterruptionType(
                rawValue: (interuptionType as AnyObject).uintValue )
            if (interuptionVal == AVAudioSession.InterruptionType.began) {
                // [self beginInterruption];
                if (isRecording) {
                    auAudioUnit.stopHardware()
                    isRecording = false
                    let audioSession = AVAudioSession.sharedInstance()
                    do {
                        try audioSession.setActive(false)
                        audioSessionActive = false
                    } catch {
                        // placeholder for error handling
                    }
                    audioInterrupted = true
                }
            } else if (interuptionVal == AVAudioSession.InterruptionType.ended) {
                // [self endInterruption];
                if (audioInterrupted) {
                    let audioSession = AVAudioSession.sharedInstance()
                    do {
                        try audioSession.setActive(true)
                        audioSessionActive = true
                        if (auAudioUnit.renderResourcesAllocated == false) {
                            try auAudioUnit.allocateRenderResources()
                        }
                        try auAudioUnit.startHardware()
                        isRecording = true
                    } catch {
                        // placeholder for error handling
                    }
                }
            }
        }
    }
}

