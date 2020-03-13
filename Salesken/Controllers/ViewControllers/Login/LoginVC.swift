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
    
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    
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
        VC.delegate = self
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String){
        let blurEffect : UIBlurEffect?
        if #available(iOS 10.0, *) {
            if #available(iOS 13.0, *) {
                blurEffect = UIBlurEffect(style: .systemMaterialDark)
            } else {
                blurEffect = UIBlurEffect(style: .dark)
            }
        } else {
             blurEffect = UIBlurEffect(style: .dark)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (_) in
            blurEffectView.removeFromSuperview()
        })
        action.setValue(UIColor.primaryColor, forKey: "titleTextColor")
        alert.addAction(action)
        //show(alert, sender: nil)
        self.present(alert, animated: true)
    }
    
}
extension LoginVC: ForgotPasswordDelegate{
    func onEmailSubmitted(email: String) {

        let message = "Check your email \(email) to reset your password"
        showAlert(title: "Email Sent",message: message)
    }
    
    
}
