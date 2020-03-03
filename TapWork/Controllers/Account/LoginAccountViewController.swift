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
    
    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerAccountButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailUser.delegate = self
        passwordUser.delegate = self
        
        activityIndicator.isHidden = true
        
        navigationController?.navigationBar.isHidden = true
        
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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    @objc func updateChangeFrame (notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
 
        if notification.name == UIResponder.keyboardWillShowNotification {

            self.bottomConstraint.constant = keyboardFrame.height + 5
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            self.bottomConstraint.constant =  100
            
            UIView.animate(withDuration: 0.25) {
                
                self.view.layoutIfNeeded()
            }
        }
    }

    //error handling method
    func displayWarning(withText text: String) {
        
        errorLabel.text = text
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
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
            self?.activityIndicator.startAnimating()
            
            self?.signInButton.titleLabel?.isHidden = true
            
            self?.activityIndicator.isHidden = false
            
            self?.displayWarning(withText: "Авторизация прошла успешно!")
            
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func registerAnAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterAccount", sender: nil)
    }
}

extension LoginAccountViewController: UITextFieldDelegate {

// скрываем клавиатуру при нажатии на Done text Field
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
}
