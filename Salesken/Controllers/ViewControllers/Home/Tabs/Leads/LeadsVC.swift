//
//  LeadsVC.swift
//  Salesken
//
//  Created by istar on 18/02/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

class LeadsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "LeadsHeaderTVCell") as! LeadsHeaderTVCell
        headerCell.headerTitleLabel.text = sectionList[section]
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadsTVCell", for: indexPath) as! LeadsTVCell
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionList
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionList.firstIndex(of: title)!
    }
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var sectionList = [String]()
    var contactList = [String]()
    
    func prepareData(){
        sectionList = ["A","B","C","D","E","F","G","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prepareData()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        searchBar.searchTextField.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LeadsTVCell", bundle: nil), forCellReuseIdentifier: "LeadsTVCell")
        tableView.register(UINib(nibName: "LeadsHeaderTVCell", bundle: nil), forCellReuseIdentifier: "LeadsHeaderTVCell")
        tableView.sectionIndexMinimumDisplayRowCount = 10
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    

}
