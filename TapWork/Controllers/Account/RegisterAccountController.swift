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
        
        delegates()
        changeStyleButton()
    }
    
    private func changeStyleButton() {
        guard let registerButton = registerButtonLabel else {return}
        
        registerButton.changeStyleButton(with: "Зарегистрировать")
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
        self.view.activityStopAnimating()
    }
    
   private func register(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isFilled(firstname: firstNameUserTextField.text,
                                  lastName: lastNameUserTextField.text,
                                  email: email,
                                  password: password)
        else {
            completion(.failure(AuthError.notFilled))
            return
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
//            let db = Firestore.firestore()
//            db.collection("users").addDocument(data: [
//                "firstName": self.firstNameUserTextField.text!,
//                "lastName": self.lastNameUserTextField.text!,
//                "email": email,
//                "uid": result!.user.uid as Any ])
            let db = Firestore.firestore()
            db.collection("users").document((result?.user.uid)!).setData([
                    "firstName": self!.firstNameUserTextField.text!,
                    "lastName": self!.lastNameUserTextField.text!,
                    "email": email,
                    "password": password,
                    "spezialization": "не указана",
                    "profileImageUrl": "",
                    "uid": result?.user.uid as Any])
            { (error) in
                if error != nil {
                    completion(.failure(AuthError.serverError))
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
    
    @IBAction func cancelButton (_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension RegisterAccountController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
