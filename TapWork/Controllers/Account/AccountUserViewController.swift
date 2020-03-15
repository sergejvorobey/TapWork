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
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
        
        emailUserLabel.text = infoUser.emailUser
    }
   
    @IBAction func signOutButton(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
           
        } catch {
            print(error.localizedDescription)
        }
        
        let launchScreenVC = storyboard?.instantiateViewController(withIdentifier: "LaunchScreen")
        
        guard let launchSVC = launchScreenVC else { return }

        self.navigationController?.pushViewController(launchSVC, animated: true)
    }
}
