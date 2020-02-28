//
//  AccountViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class LoginAccountViewController: UIViewController {
    
    let ShowAccountUserAfterLogin = "ShowAccountUserAfterLogin"

    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerAccountButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let signInButton = signInButton {
            signInButton.setTitle("Войти", for: .normal)
            signInButton.backgroundColor = .red
            signInButton.layer.cornerRadius = 15
            signInButton.tintColor = .white
        }
        
        if let registerAccountButton = registerAccountButton {
            registerAccountButton.setTitle("Зарегистрироваться", for: .normal)
            registerAccountButton.backgroundColor = .red
            registerAccountButton.layer.cornerRadius = 15
            registerAccountButton.tintColor = .white
        }
        
        if let errorLabel = errorLabel {
            errorLabel.alpha = 0
            errorLabel.textColor = .red
        }
        
        //если акк есть ->> переход в лк
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
        if user != nil{
            self?.performSegue(withIdentifier: "ShowAccountUserAfterLogin", sender: nil)
        } 
    }
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailUser.text = ""
        passwordUser.text = ""
        
    }
    
    //error handling method
    func displayWarning(withText text: String) {
        errorLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.errorLabel.alpha = 1
        }) { [weak self] complate in
            self?.errorLabel.alpha = 0
        }
    }

    
    @IBAction func signInAccount(_ sender: UIButton) {
        guard let email = emailUser.text, let password = passwordUser.text, email != "",
            password != ""
            else {
            displayWarning(withText: "Пожалуйста, заполните все поля!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarning(withText: "Неверный логин или пароль!")
                return
            }
        
            self?.displayWarning(withText: "No such user!")
        }
    }
    
    @IBAction func registerAnAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterAccount", sender: nil)
    }
    
    @IBAction func cancelButton (_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
