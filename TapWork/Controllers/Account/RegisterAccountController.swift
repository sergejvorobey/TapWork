//
//  RegisterAccountController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class RegisterAccountController: UIViewController {
    
    @IBOutlet weak var errorRegistrationLabel: UILabel!
    @IBOutlet weak var registerButtonLabel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let registerButton = registerButtonLabel {
            registerButton.setTitle("Зарегистрировать", for: .normal)
            registerButton.backgroundColor = .red
            registerButton.layer.cornerRadius = 15
            registerButton.tintColor = .white
        }
        
        if let errorRegistration = errorRegistrationLabel {
            errorRegistration.isHidden = true
            errorRegistration.tintColor = .red
        }

    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        
    }
}
