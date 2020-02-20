//
//  SpecializationViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class SpecializationController: UITableViewController {

    //@IBOutlet weak var tableView: UITableView!
    
    private var specializations: [Specialization] = []
    private let specializationsProvider: SpecializationsProvider = SpecializationsProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        specializations = specializationsProvider.specializations
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specializations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let specializationCell = tableView.dequeueReusableCell(withIdentifier: "SpecializationCell", for: indexPath) as! SpecializationCell
        
        specializationCell.specializationLabel.text = specializations[indexPath.row].nameSpecialization.rawValue
        
        return specializationCell
        
    }
    
    //MARK: update cells specialization
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//     let specializationController = storyboard?.instantiateViewController(withIdentifier: "SpecializationController")
        
//        guard let specializationVC = specializationController else { return }
//
//        self.navigationController?.pushViewController(specializationVC, animated: true)
    

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func applyFilterButton(_ sender: UIBarButtonItem) {
        
        
    }

}
