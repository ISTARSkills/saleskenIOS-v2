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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Call") { action, index in
            let newStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let VC = newStoryBoard.instantiateViewController(withIdentifier: "CallDialerTabVC") as! CallDialerTabVC
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        }
        more.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6980392157, blue: 0.5019607843, alpha: 1)
        return [more]
    }
    
     
    @IBOutlet weak var dateDropBtn: UIButton!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!

    
    fileprivate let datePicker = ToolbarDatePickerView()
    override func viewDidAppear(_ animated: Bool) {
        let dash = UIApplication.shared.windows[0].rootViewController as! DashBoardVC
        dash.delegate = self
        tableView.reloadData()
    }
    
    func configureDatePicker(){
        self.dateTxt.inputView = self.datePicker
        self.dateTxt.inputAccessoryView = self.datePicker.toolbar
        self.dateTxt.autocorrectionType = .no
        self.dateTxt.inputAssistantItem.leadingBarButtonGroups.removeAll()
        self.dateTxt.inputAssistantItem.trailingBarButtonGroups.removeAll()
        self.datePicker.toolbarDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dash : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dashboard = dash.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        dashboard.delegate = self
        
        self.setNeedsStatusBarAppearanceUpdate()
        configureDatePicker()
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
extension UpComingVC: ToolbarDatePickerViewDelegate{
     func onDatePickerDone() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        self.dateTxt.text = formatter.string(from: datePicker.date)
        self.dateTxt.resignFirstResponder()
    }
       
    func onDatePickerCancel() {
        self.dateTxt.text = nil
        self.dateTxt.resignFirstResponder()
    }
}

extension UpComingVC: SearchDelegate {
    func onSearchStateChange(status: Bool) {
        print(status)
    }
    
    func onSearchTextChange(data: String) {
        print(data)
    }
    
    
}
 
