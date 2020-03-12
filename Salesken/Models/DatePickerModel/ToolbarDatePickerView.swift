//
//  ToolbarDatePickerView.swift
//  Salesken
//
//  Created by Anup on 10/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import Foundation
import UIKit

protocol ToolbarDatePickerViewDelegate: class {
    func onDatePickerDone()
    func onDatePickerCancel()
}

//Custom DatePicker 
class ToolbarDatePickerView: UIDatePicker {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarDatePickerViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        backgroundColor = .white
        datePickerMode = .date
        maximumDate = Date()
        setValue(UIColor.black, forKeyPath: "textColor")
        setValue(false, forKey: "highlightsToday")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        toolBar.barStyle = .blackOpaque
        toolBar.barTintColor = .primaryColor
        toolBar.isTranslucent = true
        toolBar.tintColor = .white
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
       // let title = UIBarButtonItem(title: "Choose the date", style: .plain, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.onDatePickerDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.onDatePickerCancel()
    }
}
