//
//  LoginVC.swift
//  Salesken
//
//  Created by Anup on 12/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var topPaletteImageView: UIImageView!
    @IBOutlet weak var downPaletteImageView: UIImageView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var signinBtn: SaleskenButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Socket.instance.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        nameTxt.addBottomBorder()
        passwordTxt.addBottomBorder()
        signinBtn.layer.cornerRadius = 10
        signinBtn.clipsToBounds = true
        nameTxt.tintColor = .primaryColor
        passwordTxt.tintColor = .primaryColor
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginGradientButton()
    }
    
    func loginGradientButton() -> Void {
        let gradientColor = CAGradientLayer()
        gradientColor.frame = signinBtn.frame
        let color1: UIColor = .primaryColor
        let color2 = UIColor(red: 217.0/255.0, green: 60.0/255.0, blue: 86.0/255.0, alpha: 1)
        let color3 = UIColor(red: 191.0/255.0, green: 38.0/255.0, blue: 63.0/255.0, alpha: 1)
        gradientColor.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
       // gradientColor.locations = [0.0, 0.2, 0.3]
        self.signinBtn.layer.insertSublayer(gradientColor, at: 0)
    }
    
    
    
    @IBAction func onClickSignin(_ sender: Any) {
        guard let email = nameTxt.text else {return}
        if email.isValidEmail{
            print("Valid")
        }else{
            print("invalid")
        }
    }
    
    @IBAction func onClickForgotPassword(_ sender: Any) {
        let newStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let VC = newStoryBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
       // VC.delegate = self
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
     
    
}
 
