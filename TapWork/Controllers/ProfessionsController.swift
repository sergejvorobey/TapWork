//
//  ProfessionsController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 05/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ProfessionsController: UITableViewController {
    
    var professions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "Профессия"
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return professions.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let professionCell = tableView.dequeueReusableCell(withIdentifier: "ProfessionCell", for: indexPath) as! ProfessionCell
        
        let profession = professions[indexPath.row]
        
        professionCell.professionLabel.text = profession
        
        return professionCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        //        var city: Items
        //
        //        if isFiltering {
        //            city = filteredCitiesList[indexPath.row]
        //            print("Выбрано: \(String(describing: city.title)) \(indexPath)")
        //
        //        } else {
        //            city = citiesList[indexPath.row]
        //            print("Выбрано: \(String(describing: city.title)) \(indexPath)")
        //        }
        
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
}
