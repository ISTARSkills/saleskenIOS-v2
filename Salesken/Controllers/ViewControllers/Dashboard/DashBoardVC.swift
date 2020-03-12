//
//  DashBoardVC.swift
//  Salesken
//
//  Created by Anup on 11/03/20.
//  Copyright © 2020 Salesken.ai. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func onSearchStateChange(status: Bool)
    func onSearchTextChange(data: String)
}

class DashBoardVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
     
    var delegate: SearchDelegate!
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.setNeedsStatusBarAppearanceUpdate()
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .clear
        headerView.backgroundColor = .primaryColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     
}
extension DashBoardVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        self.delegate.onSearchStateChange(status: self.isSearching)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        self.delegate.onSearchStateChange(status: self.isSearching)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate.onSearchTextChange(data: searchText)
    }
}
