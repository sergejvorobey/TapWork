//
//  RegisterAccountController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class RegisterAccountController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameUserTextField: UITextField!
    @IBOutlet weak var passwordUserTextField: UITextField!
    @IBOutlet weak var confirmPassUserTextField: UITextField!
    
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
            errorRegistration.alpha = 0
            errorRegistration.textColor = .red
    }
}
    
    func displayWarning(withText text: String) {
        errorRegistrationLabel.text = text
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.errorRegistrationLabel.alpha = 1
        }) { [weak self] complate in
            self?.errorRegistrationLabel.alpha = 0
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let nameUser = nameUserTextField.text ,
            let password = passwordUserTextField.text,
            let confirmPassword = confirmPassUserTextField.text,
            email != "",
            nameUser != "",
            password != "",
            confirmPassword != ""
            //confirmPassword != password
                   else {
                   displayWarning(withText: "Пожалуйста, заполните все поля!")
                   return
            }
        UserDefaults.standard.set(true, forKey: "registering")
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    
                } else {
                    self?.displayWarning(withText: "Пользователь не создан")
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
