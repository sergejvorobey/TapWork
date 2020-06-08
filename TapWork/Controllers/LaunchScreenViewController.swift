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
    private var userStatus: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        view.changeColorView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        checkUser()

    }
    
    private func checkUserAuth(completion: @escaping (AuthResult) -> Void) {

        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        Auth.auth().addStateDidChangeListener {[weak self](auth, user) in

            let delay = 2
            self?.view.activityStartAnimating(activityColor: UIColor.red, backgroundColor: UIColor.black.withAlphaComponent(0.0))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {

                switch user {
                case _ where user != nil:
                    completion(.success)
                    self?.performSegue(withIdentifier: "MainVC", sender: nil)
                case _ where user == nil:
                    completion(.success)
                    //                print("Jump Login screen")
                    self?.performSegue(withIdentifier: "LoginAccountController", sender: nil)
                default:
                    completion(.failure(AuthError.unknownError))
                    
                }
            }
        }
    }

    private func checkUser() {
        checkUserAuth {[weak self] (result) in
            switch result {
            case .success:
                //             self.showAlert(title: "Успешно", message: "Вы авторизованы!")
            print("Jump choice screen")
               //              self.performSegue(withIdentifier: "MainVC", sender: nil)
            case .failure(let error):
                self?.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

