//
//  Audio.swift
//  Salesken
//
//  Created by Anup on 11/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import AVFoundation

@available(iOS 10.0, *)
func configureAudioSession() {
  print("Configuring audio session")
  let session = AVAudioSession.sharedInstance()
  do {
    try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
  } catch (let error) {
    print("Error while configuring audio session: \(error)")
    //Socket.instance.disconnect()
  }
   
}

func startAudio() {
   let recordAudio = RecordAudio()
   recordAudio.startRecording()
}

func stopAudio() {
   let recordAudio = RecordAudio()
   recordAudio.stopRecording()
}

