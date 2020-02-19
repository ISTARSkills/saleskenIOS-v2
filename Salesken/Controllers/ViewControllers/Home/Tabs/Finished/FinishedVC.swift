//
//  FinishedVC.swift
//  Salesken
//
//  Created by istar on 18/02/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

class FinishedVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        searchBar.searchTextField.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
