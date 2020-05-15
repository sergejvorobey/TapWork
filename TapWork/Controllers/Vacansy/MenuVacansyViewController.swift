//
//  MenuVacansyViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 26/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class MenuVacansyViewController: UIViewController {
    
    @IBOutlet weak var userAccountLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle()
        
    }
    
    @IBAction func userAccountButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowUserAccount", sender: nil)
    }
}

extension MenuVacansyViewController {
    
    private func setupButtonStyle() {
        
        navigationItem.title = "Меню"
 
        guard let userAccount = userAccountLabel else {return}
        
        userAccount.changeButtonDisclosure(with: "Личный кабинет")

    }
}

