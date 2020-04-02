//
//  RegisterAccountController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterAccountController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameUserTextField: UITextField!
    @IBOutlet weak var lastNameUserTextField: UITextField!
    @IBOutlet weak var passwordUserTextField: UITextField!
    @IBOutlet weak var confirmPassUserTextField: UITextField!
    
    @IBOutlet weak var registerButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        firstNameUserTextField.delegate = self
        lastNameUserTextField.delegate = self
        passwordUserTextField.delegate = self
        confirmPassUserTextField.delegate = self
        
        if let registerButton = registerButtonLabel {
            registerButton.setTitle("Зарегистрировать", for: .normal)
            registerButton.backgroundColor = .red
            registerButton.layer.cornerRadius = 15
            registerButton.tintColor = .white
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let firstName = firstNameUserTextField.text ,
            let lastName = lastNameUserTextField.text,
            let password = passwordUserTextField.text,
            let confirmPassword = confirmPassUserTextField.text,
            email != "",
            firstName != "",
            lastName != "",
            password != "",
            confirmPassword != ""
            //confirmPassword != password
            else {
                alertError(withMessage: "Пожалуйста, заполните все поля!")
                return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    let db = Firestore.firestore()
                    db.collection("users").document((user?.user.uid)!).setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "password": password,
                        "uid": user?.user.uid as Any]) { (error) in
                            //                    db.collection("users").addDocument(data: [
                            //                        "firstName": firstName,
                            //                        "lastName": lastName,
                            //                        "email": email,
                            //                        "uid": user?.user.uid as Any ]) { (error) in
                            if error == nil {
                                self?.performSegue(withIdentifier: "MainScreenController", sender: nil)
                            }
                    }
                } else {
                    self?.alertError(withMessage: "Пользователь не создан")
                }
            } else {
                print(error!.localizedDescription)
                self?.alertError(withMessage: "Адрес электронной почты уже используется другой учетной записью.")
            }
        }
    }
    
    @IBAction func cancelButton (_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}


