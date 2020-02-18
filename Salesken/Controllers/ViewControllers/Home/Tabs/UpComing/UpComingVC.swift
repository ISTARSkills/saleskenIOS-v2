//
//  ViewController.swift
//  Salesken
//
//  Created by istar on 18/02/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

class UpComingVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpComingTVCell", for: indexPath) as! UpComingTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Call", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("call action ...")
            success(true)
        })
        modifyAction.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6980392157, blue: 0.5019607843, alpha: 1)
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        searchBar.searchTextField.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "UpComingTVCell", bundle: nil), forCellReuseIdentifier: "UpComingTVCell")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

