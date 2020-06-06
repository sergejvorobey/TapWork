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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //    private let showAlert = ShowError()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStyleButton()
        changeFrameKeyboard()
        delegates()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //        navigationController?.navigationBar.isHidden = true
    }
    
    private func delegates() {
        emailUser.delegate = self
        passwordUser.delegate = self
    }
    
    // When the keyboard appears, indent from the keyboard to the buttons
    private func changeFrameKeyboard() {
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
    
    // change style button
    private func changeStyleButton() {
        guard let signInButton = signInButton,
            let registerAccountButton = registerAccountButton else {return}
        
        signInButton.changeStyleButton(with: "Войти")
        registerAccountButton.changeStyleButton(with: "Зарегистрироваться")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.activityStopAnimating()
        emailUser.text = ""
        passwordUser.text = ""
    }
    
    private func singIn(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isFilledEmailOrPassword(email: email,
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
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let _ = result else {
                completion(.failure(AuthError.fieldsDataNotFound))
                return
            }
            if error == nil {
                completion(.success)
            }
        }
    }
    
    @IBAction func signInAccount(_ sender: UIButton) {
        
        singIn(email: emailUser.text, password: passwordUser.text) {[weak self] (result) in
            switch result {
            case .success:
                //                self.showAlert(title: "Успешно", message: "Вы авторизованы!")
                self?.view.activityStartAnimating(activityColor: .red,
                                                 backgroundColor: UIColor.black.withAlphaComponent(0.1))
            case .failure(let error):
                self?.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func registerAnAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "chooseStatus", sender: nil)
    }
}

extension LoginAccountViewController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
