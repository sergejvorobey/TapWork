//
//  SpecializationViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class SpecializationController: UITableViewController {
    
    var specializations = [Specializations]()
    var markerForSelectProfession = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "Специализация"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return specializations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let specializationCell = tableView.dequeueReusableCell(withIdentifier: "SpecializationCell", for: indexPath) as! SpecializationCell
        
        let specialization = specializations[indexPath.row]
        
        specializationCell.specializationLabel.text = specialization.name
        specializationCell.accessoryType = .disclosureIndicator
        
        return specializationCell
        
    }
    
    //MARK: update cells specialization
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ProfessionsController" {
                
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                
                let professions = specializations[indexPath.row]
                let categoryInfoVC = segue.destination as! ProfessionsController
                categoryInfoVC.markerForSelectProfession = markerForSelectProfession
                
                for profession in [professions] {
                    categoryInfoVC.professions = profession.professions as! [String]
                }
            }
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
