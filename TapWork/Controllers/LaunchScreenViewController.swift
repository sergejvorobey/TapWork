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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headingApp: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUser()
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // метод проверяет на наличие реги юзера
   private func checkUser() {
        
        let delay = 2 // seconds

        activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0,width: 150.0, height: 150.0)
        activityIndicator.style = .large

        self.activityIndicator.startAnimating()
        
    //если акк есть ->> на главный экран
    Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            
    if user != nil{
            
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {

        self?.activityIndicator.stopAnimating()

        self?.performSegue(withIdentifier: "MainVC", sender: nil)

        }

    } else {
            
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                
        self?.activityIndicator.stopAnimating()
                
        self?.performSegue(withIdentifier: "LoginAccountController", sender: nil)
                
                }
            }
        }
    }
}

