//
//  ForgotPasswordVC.swift
//  Salesken
//
//  Created by Anup on 13/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

protocol ForgotPasswordDelegate {
    func onEmailSubmitted(email: String)
}

class ForgotPasswordVC: UIViewController {

    var delegate: ForgotPasswordDelegate!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        emailTxt.addBottomBorder()
        sendBtn.layer.cornerRadius = 10
        sendBtn.clipsToBounds = true
        emailTxt.tintColor = .primaryColor
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        sendGradientButton()
    }
     
    @IBAction func onClickSend(_ sender: Any) {
        guard let email = emailTxt.text else {return}
        if email.isValidEmail{
            print("Valid")
            dismiss(animated: true) {
                self.delegate.onEmailSubmitted(email: email)
            }
        }else{
            print("invalid")
        }
        
    }
    func sendGradientButton() -> Void {
        let gradientColor = CAGradientLayer()
        gradientColor.frame = sendBtn.frame
        let color1: UIColor = .primaryColor
        let color2 = UIColor(red: 217.0/255.0, green: 60.0/255.0, blue: 86.0/255.0, alpha: 1)
        let color3 = UIColor(red: 191.0/255.0, green: 38.0/255.0, blue: 63.0/255.0, alpha: 1)
        gradientColor.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
       // gradientColor.locations = [0.0, 0.2, 0.3]
        self.sendBtn.layer.insertSublayer(gradientColor, at: 0)
    }
}
