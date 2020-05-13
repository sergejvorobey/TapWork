//
//  MenuVacansyViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 26/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class MenuVacansyViewController: UIViewController {
    
    @IBOutlet weak var addVacansyButtonLabel: UIButton!
    @IBOutlet weak var userAccountLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle()
        
    }
    
    @IBAction func addVacansyButton(_ sender: UIButton) {
        performSegue(withIdentifier: "AddVacansy", sender: nil)
    }
    
    @IBAction func userAccountButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowUserAccount", sender: nil)
    }
}

extension MenuVacansyViewController {
    
    private func setupButtonStyle() {
        
        navigationItem.title = "Меню"
 
        guard let addButton = addVacansyButtonLabel,
            let userAccount = userAccountLabel else {return}
        
        addButton.changeButtonDisclosure(with: "Создать вакансию")
        userAccount.changeButtonDisclosure(with: "Личный кабинет")

        
//        disclosureAddVacansy.frame = addButton.bounds
//        disclosureUserAccount.frame = userAccount.bounds
//        
//        disclosureAddVacansy.accessoryType = .disclosureIndicator
//        disclosureUserAccount.accessoryType = .disclosureIndicator
//        
//        disclosureAddVacansy.isUserInteractionEnabled = false
//        disclosureUserAccount.isUserInteractionEnabled = false
//        
//        addButton.setTitle("Создать вакансию", for: .normal)
//        addButton.tintColor = .black
//        addButton.layer.cornerRadius = 25
//        addButton.layer.borderWidth = 0.5
//        addButton.layer.masksToBounds = true
//        
//        userAccount.setTitle("Личный кабинет", for: .normal)
//        userAccount.tintColor = .black
//        userAccount.layer.cornerRadius = 25
//        userAccount.layer.borderWidth = 0.5
//        userAccount.layer.masksToBounds = true
//        
//        addButton.addSubview(disclosureAddVacansy)
//        userAccount.addSubview(disclosureUserAccount)
    }
    
}

