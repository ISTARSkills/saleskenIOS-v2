//
//  SaleskenButton.swift
//  Salesken
//
//  Created by Anup on 17/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit
@IBDesignable
final class SaleskenButton: UIButton {

    var borderWidth: CGFloat = 2.0
    var borderColor = UIColor.white.cgColor

    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(UIColor.black,for: .normal)
        }
    }

    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        let color1: UIColor = .primaryColor
        let color2 = UIColor(red: 217.0/255.0, green: 60.0/255.0, blue: 86.0/255.0, alpha: 1)
        let color3 = UIColor(red: 191.0/255.0, green: 38.0/255.0, blue: 63.0/255.0, alpha: 1)
        
        gradientLayer.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
