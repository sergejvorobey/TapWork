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
import iOSDropDown

class RegisterAccountController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameUserTextField: UITextField!
    @IBOutlet weak var lastNameUserTextField: UITextField!
    @IBOutlet weak var dateBirthUserTextField: UITextField!
    @IBOutlet weak var cityUserTextField: DropDown!
    @IBOutlet weak var passwordUserTextField: UITextField!
    @IBOutlet weak var confirmPassUserTextField: UITextField!
    @IBOutlet weak var registerButtonLabel: UIButton!
    
    private var citiesList = [Items]()
    var roleUser = "Ищу работу"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        changeStyleButton()
        setupBirthPicker()
        
    }
    
    // load cities
    private func loadCitiesData() {
        
        let dataLoader = CitiesLoaderAPI()
        dataLoader.getAllCitiesName()
        
        dataLoader.completionHandler { [weak self] (cities, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _cities = cities else {return}
                
                self.citiesList = _cities
                
                var arrayCities = [String]()
                
                for city in self.citiesList {
                    arrayCities.append(city.title!)
                    self.cityUserTextField.optionArray = arrayCities
                }
            }
        }
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
        navigationItem.title = "Регистарция"
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
        loadCitiesData()
    }
    
    private func register(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        if roleUser == "Работодатель" {
            guard Validators.isFilledRegisterEmployer(firstname: firstNameUserTextField.text,
                                                      lastName: lastNameUserTextField.text,
                                                      city: cityUserTextField.text,
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
                                              city: cityUserTextField.text,
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
            
//            if error == nil {
//                let db = Firestore.firestore()
                //            db.collection("users")
                //                .document((result?.user.uid)!)
                //                .setData(["userData":
                //                            ["firstName": self!.firstNameUserTextField.text!,
                //                             "lastName": self!.lastNameUserTextField.text!,
                //                             "birth": self!.dateBirthUserTextField.text ?? "Не указано",
                //                             "city": self!.cityUserTextField.text!,
                //                             "email": email,
                //                             "dateRegister": Timestamp(),
                //                             "password": password,
                //                             "roleUser": self!.roleUser,
                //                             "profileImageUrl": "",
                //                             "uid": result?.user.uid as Any],
                //                          "professionData":
                //                            ["profession": "Не указано",
                //                             "experience": "Не указано",
                //                             "aboutMe": "Не указано"],
                //                          "employerData":
                //                            ["activeVacansy": 0,
                //                             "draft": 0]
                //                ])
                //                 completion(.success)
                //            } else {
                //                completion(.failure(AuthError.unknownError))
                //            }
                if error == nil {
                    let db = Firestore.firestore()
                    db.collection("users")
                        .document((result?.user.uid)!)
                        .collection("userData")
                        .document("basic").setData([
                            "firstName": self!.firstNameUserTextField.text!,
                            "lastName": self!.lastNameUserTextField.text!,
                            "city": self!.cityUserTextField.text!,
                            "email": email,
                            "dateRegister": Timestamp(),
                            "birth": self!.dateBirthUserTextField.text ?? "Не указано",
                            "password": password,
                            "roleUser": self!.roleUser,
                            "profileImageUrl": "",
                            "uid": result?.user.uid as Any ])
                    
                    db.collection("users")
                        .document((result?.user.uid)!)
                        .collection("userData")
                        .document("profession").setData([
                            "aboutMe": "Не указано",
                            "experience": "Не указано",
                            "profession": "Не указано"])
                    
                    db.collection("users")
                        .document((result?.user.uid)!)
                        .collection("userData")
                        .document("employer").setData([
                            "activeVacansy": 0,
                            "draft": 0])
                    
                    completion(.success)
                } else {
                    completion(.failure(AuthError.unknownError))
//                }
            }
        }
    }
    //            if error == nil {
    //                let db = Firestore.firestore()
    //                if self?.roleUser == "Ищу работу" {
    //                    db.collection("users")
    //                        .document((result?.user.uid)!)
    //                        .collection("userData")
    //                        .document("personalData").setData([
    //                            "firstName": self!.firstNameUserTextField.text!,
    //                            "lastName": self!.lastNameUserTextField.text!,
    //                            "city": self!.cityUserTextField.text!,
    //                            "email": email,
    //                            "dateRegister": Timestamp(),
    //                            "birth": self!.dateBirthUserTextField.text!,
    //                            "password": password,
    //                            "roleUser": self!.roleUser,
    //                            "profileImageUrl": "",
    //                            "uid": result?.user.uid as Any ])
    //                } else {
    //                    db.collection("users")
    //                        .document((result?.user.uid)!)
    //                        .collection("userData")
    //                        .document("personalData").setData([
    //                            "firstName": self!.firstNameUserTextField.text!,
    //                            "lastName": self!.lastNameUserTextField.text!,
    //                            "city": self!.cityUserTextField.text!,
    //                            "email": email,
    //                            "dateRegister": Timestamp(),
    //                            "birth": "Не указано",
    //                            "password": password,
    //                            "roleUser": self!.roleUser,
    //                            "profileImageUrl": "",
    //                            "uid": result?.user.uid as Any ])
    //                }
    //                completion(.success)
    //            } else {
    //                completion(.failure(AuthError.unknownError))
    //            }
    //        }
    //    }
    
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
