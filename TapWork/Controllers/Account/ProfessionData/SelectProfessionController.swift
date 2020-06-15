//
//  SelectProfessionController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 14/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import BonsaiController

class SelectProfessionController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let categories = DataLoader().categoryData
    private var professions = [String]()
    private var filteredProfession = [String]()
    var checkProfession: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Специализации"
        getDataProfession()
        tableView.tableFooterView = UIView()
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
        tableView.isHidden = true
    }
    
    private func getDataProfession() {
        var array = [String]()
        for specializations in categories {
            guard let professionsList = specializations.specialization else {return}
            for prof in professionsList {
                _ = prof.professions.flatMap { (element) -> String in
                    array.append(element!)
                    return element!
                }
                professions = array.sorted()
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension SelectProfessionController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredProfession.count
        }
        return professions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectProfessionCell", for: indexPath) as! SelectProfessionCell
        
        var profession: String
        
        if isFiltering {
            profession = filteredProfession[indexPath.row]
        } else {
            profession = professions[indexPath.row]
        }
        
        cell.professionLabel?.text = profession
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isFiltering {
            checkProfession = filteredProfession[indexPath.row]
        } else {
            checkProfession = professions[indexPath.row]
        }
        performSegue(withIdentifier: "unwindToCreateExp", sender: nil)
    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//
//        checkProfession = ""
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 1 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
}

// MARK: Input Search Bar and design
extension SelectProfessionController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBar () {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по специализации"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.isActive = true
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredProfession = professions.filter({ (prof: String) -> Bool in
            return (prof.lowercased().contains(searchText.lowercased()))
        })
        
        tableView.reloadData()
    }
}

