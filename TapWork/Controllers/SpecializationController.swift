//
//  SpecializationViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class SpecializationController: UITableViewController {
    
    var specializations = [CategoriesList]()
    private var professions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpecializations()
        tableView.tableFooterView = UIView()
        
    }
    
    private func showSpecializations()  {
        
        var profession = [String]()
        
        for specialization in specializations {
            navigationItem.title = specialization.nameCategory
            profession = specialization.listOfSpecializations as! [String]
            professions.append(contentsOf: profession)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.title = "Cпециализации"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return professions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let specializationCell = tableView.dequeueReusableCell(withIdentifier: "SpecializationCell", for: indexPath) as! SpecializationCell
        
        let specialization = professions[indexPath.row]
        
        specializationCell.specializationLabel.text = specialization
//        specializationCell.c
        
        return specializationCell
        
    }
    
    //MARK: update cells specialization
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func applyFilterButton(_ sender: UIBarButtonItem) {
        
    }
}
