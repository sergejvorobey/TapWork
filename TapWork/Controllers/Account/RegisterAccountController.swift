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
    @IBOutlet weak var dateBirthUserTextField: UITextField!
    @IBOutlet weak var passwordUserTextField: UITextField!
    @IBOutlet weak var confirmPassUserTextField: UITextField!
    @IBOutlet weak var registerButtonLabel: UIButton!
    var roleUser = "Ищу работу"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        changeStyleButton()
        setupBirthPicker()
        navigationItem.title = "Регистрация"
        
    }
    
    private func setupBirthPicker() {
        self.dateBirthUserTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateBirthUserTextField.inputView as? UIDatePicker { // 2-1
            let dateFormatter = DateFormatter() // 2-2
            dateFormatter.dateStyle = .medium // 2-3
            dateFormatter.locale = Locale(identifier: "ru_RU")
            self.dateBirthUserTextField.text = dateFormatter.string(from: datePicker.date) //2-4
        }
        self.dateBirthUserTextField.resignFirstResponder() // 2-5
    }
    
    private func changeStyleButton() {
        guard let registerButton = registerButtonLabel else {return}
        registerButton.changeStyleButton(with: "Зарегистрировать")
        
    }
    
    private func checkStatus() {
        if roleUser == "Работодатель" {
            dateBirthUserTextField.isHidden = true
        } else {
            dateBirthUserTextField.isHidden = false
        }
    }
    
    private func delegates() {
        emailTextField.delegate = self
        firstNameUserTextField.delegate = self
        lastNameUserTextField.delegate = self
        passwordUserTextField.delegate = self
        confirmPassUserTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkStatus()
        self.view.activityStopAnimating()
    }
    
    private func register(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        if roleUser == "Работодатель" {
            guard Validators.isFilledRegisterEmployer(firstname: firstNameUserTextField.text,
                                                      lastName: lastNameUserTextField.text,
                                                      email: email,
                                                      password: password)
                else {
                    completion(.failure(AuthError.notFilled))
                    return
            }
        } else {
            guard Validators.isFilledRegister(firstname: firstNameUserTextField.text,
                                              lastName: lastNameUserTextField.text,
                                              birth: dateBirthUserTextField.text,
                                              email: email,
                                              password: password)
                else {
                    completion(.failure(AuthError.notFilled))
                    return
            }
        }
        guard let email = email, let password = password else {
            completion(.failure(AuthError.unknownError))
            return
        }
        
        guard Validators.isSimpleEmail(email) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] (result, error) in
            guard let _ = result else {
                completion(.failure(error!))
                return
            }
            //            db.collection("users").document((result?.user.uid)!).setData([
            //                    "firstName": self!.firstNameUserTextField.text!,
            //                    "lastName": self!.lastNameUserTextField.text!,
            //                    "city": "не указан",
            //                    "email": email,
            //                    "dateRegister": Timestamp(),
            //                    "birth": self!.dateBirthUserTextField.text!,
            //                    "password": password,
            //                    "roleUser": "Соискатель",
            //                    "spezialization": "не указана",
            //                    "profileImageUrl": "",
            //                    "uid": result?.user.uid as Any])
            
            if error == nil {
                let db = Firestore.firestore()
                if self?.roleUser == "Ищу работу" {
                    db.collection("users")
                        .document((result?.user.uid)!)
                        .collection("userData")
                        .document("personalData").setData([
                            "firstName": self!.firstNameUserTextField.text!,
                            "lastName": self!.lastNameUserTextField.text!,
                            "city": "не указан",
                            "email": email,
                            "dateRegister": Timestamp(),
                            "birth": self!.dateBirthUserTextField.text!,
                            "password": password,
                            "roleUser": self!.roleUser,
                            "profileImageUrl": "",
                            "uid": result?.user.uid as Any ])
                } else {
                    db.collection("users")
                        .document((result?.user.uid)!)
                        .collection("userData")
                        .document("personalData").setData([
                            "firstName": self!.firstNameUserTextField.text!,
                            "lastName": self!.lastNameUserTextField.text!,
                            "city": "не указан", //TODO
                            "email": email,
                            "dateRegister": Timestamp(),
                            "birth": "Не указано",
                            "password": password,
                            "roleUser": self!.roleUser,
                            "profileImageUrl": "",
                            "uid": result?.user.uid as Any ])
                }
                completion(.success)
            }
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        register(email: emailTextField.text, password: passwordUserTextField.text) {[weak self] (result) in
            switch result {
            case .success:
                //                self.showAlert(title: "Успешно", message: "Вы зарегистрированны!")
                self?.view.activityStartAnimating(activityColor: .red,
                                                  backgroundColor: UIColor.black.withAlphaComponent(0.1))
                self?.performSegue(withIdentifier: "MainScreenController", sender: nil)
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

extension RegisterAccountController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
