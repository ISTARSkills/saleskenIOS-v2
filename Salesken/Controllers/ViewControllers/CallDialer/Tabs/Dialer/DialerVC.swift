//
//  DialerVC.swift
//  Salesken
//
//  Created by Anup on 09/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

class DialerVC: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
