//
//  DialerVC.swift
//  Salesken
//
//  Created by Anup on 09/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class DialerVC: UIViewController {
    
    
    @IBOutlet weak var numberTxt: UITextField!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var numbarPadView: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    var callManager: CallManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.setNeedsStatusBarAppearanceUpdate()
        
        callManager = AppDelegate.shared.callManager
        numberTxt.inputView = UIView()
        numberTxt.text = ""

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //Socket.instance.connect()
        //Socket.instance.writeString(data: "hi ")
    }
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickNumbers(_ sender: UIButton) {
        numberTxt.text = numberTxt.text! + String(sender.tag)
    }
    
    @IBAction func onDeleteNumber(_ sender: UIButton) {
        if numberTxt.text?.count == 1 {
            numberTxt.deleteBackward()
            numberTxt.resignFirstResponder()
        }else{
            numberTxt.becomeFirstResponder()
            numberTxt.deleteBackward()
        }
    }
    
    func startOutgoingCall(mobile: String, isVideo: Bool){
        callManager.startCall(handle: mobile, videoEnabled: isVideo)
    }
    func startIncomingCall(mobile: String, isVideo: Bool){
        let backgroundTaskIdentifier =
          UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          AppDelegate.shared.displayIncomingCall(
            uuid: UUID(),
            handle: mobile,
            hasVideo: isVideo
          ) { _ in
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
          }
        }
    }
    
    @IBAction func onClickCall(_ sender: Any) {
        guard let handle = numberTxt.text else {return}
        if handle.count == 10 {
            let videoEnabled = true
            startOutgoingCall(mobile: handle, isVideo: videoEnabled)
        }
    }
    
    
    deinit {
       //Socket.instance.disconnect()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
