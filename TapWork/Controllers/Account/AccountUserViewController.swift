//
//  AccountUserViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 24/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class AccountUserViewController: UIViewController {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var emailUserLabel: UILabel!
    @IBOutlet weak var specializationUserLabel: UILabel!
    @IBOutlet weak var workExperienceUserLabel: UILabel!
    
    private var infoUser: Users!
    private var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
        
        emailUserLabel.text = infoUser.emailUser
//        nameUserLabel.text = infoUser.userName
    }
    
    @IBAction func signOutButton(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
           
        } catch {
            print(error.localizedDescription)
        }
         dismiss(animated: true)
    }
    
    @IBAction func transitionButton(_ sender: UIBarButtonItem) {
        tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}
