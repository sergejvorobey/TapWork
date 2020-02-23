//
//  AccountViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 16/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    
    @IBOutlet weak var loginUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let signInButton = signInButton {
            signInButton.backgroundColor = .red
            signInButton.layer.cornerRadius = 15
            signInButton.tintColor = .white
        }
        
        if let signOutButton = signOutButton {
            signOutButton.backgroundColor = .red
            signOutButton.layer.cornerRadius = 15
            signOutButton.tintColor = .white
        }
        
        if let errorLabel = errorLabel {
            errorLabel.isHidden = true
            errorLabel.tintColor = .red
        }
        
    }
    

    @IBAction func cancelButton(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInAccount(_ sender: UIButton) {
    }
    
    @IBAction func signOutAccount(_ sender: UIButton) {
    }
    
}
