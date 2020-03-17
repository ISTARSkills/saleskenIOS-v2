//
//  ForgotPasswordVC.swift
//  Salesken
//
//  Created by Anup on 13/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

//protocol ForgotPasswordDelegate {
//    func onEmailSubmitted(email: String)
//}

class ForgotPasswordVC: UIViewController {

     
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var centreImgView: UIImageView!
    //var delegate: ForgotPasswordDelegate!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var sendBtn: SaleskenButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        emailTxt.addBottomBorder()
        sendBtn.layer.cornerRadius = 10
        sendBtn.clipsToBounds = true
        emailTxt.tintColor = .primaryColor
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        sendGradientButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = 100.0 
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
     
    @IBAction func onClickSend(_ sender: Any) {
        guard let email = emailTxt.text else {return}
        if email.isValidEmail{
            print("Valid")
            let message = "Check your email \(email) to reset your password"
            self.showAlert(title: "Email Sent", message: message)
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
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            self.dismiss(animated: true, completion: nil)
        })
        action.setValue(UIColor.primaryColor, forKey: "titleTextColor")
        alert.addAction(action)
        //show(alert, sender: nil)
        self.present(alert, animated: true)
    }
}
