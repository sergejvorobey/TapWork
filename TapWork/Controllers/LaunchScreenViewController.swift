//
//  LaunchScreenViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var headingApp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUser()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    private func checkUserAuth(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        Auth.auth().addStateDidChangeListener {(auth, user) in
            
            let delay = 2
            self.view.activityStartAnimating(activityColor: UIColor.red, backgroundColor: UIColor.black.withAlphaComponent(0.1))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                
                switch user {
                case _ where user != nil:
                    completion(.success)
                    //                print("Jump Main screen")
                    self.performSegue(withIdentifier: "MainVC", sender: nil)
                case _ where user == nil:
                    completion(.success)
                    //                print("Jump Login screen")
                    self.performSegue(withIdentifier: "LoginAccountController", sender: nil)
                default:
                    completion(.failure(AuthError.unknownError))
                    
                }
            }
        }
    }
    
    private func checkUser() {
        checkUserAuth { (result) in
            switch result {
            case .success:
                //             self.showAlert(title: "Успешно", message: "Вы авторизованы!")
                print("Jump choice screen")
               //              self.performSegue(withIdentifier: "MainVC", sender: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

