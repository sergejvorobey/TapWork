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
    
    private var infoUser: Users!
    private var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: TODO
        imageUser.layer.borderWidth = 1
        imageUser.layer.masksToBounds = false
        imageUser.layer.cornerRadius = imageUser.frame.height / 2
        imageUser.clipsToBounds = true
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil, action: nil)
            
            guard let currentUsers = Auth.auth().currentUser else { return }
            infoUser = Users(user: currentUsers)
            ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let db = Firestore.firestore()

        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if let error = error {
                print("Error retreiving collection: \(error)")
            } else {
                guard let firstName = userData["firstName"],
                    let email = userData["email"],
                    let lastName = userData["lastName"] else {return}
                let specialization = userData["spezialization"] ?? "не указана"
                let fullName = """
                \(firstName)
                \(lastName)
                """
                self?.nameUserLabel.text = fullName
                self?.emailUserLabel.text = email as? String
                self?.specializationUserLabel.text = "Профессия: \(specialization)"
            }
        }
    }
   
    @IBAction func menuAccount(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Назад", style: .default) { _ in }
        let signOutAcc = UIAlertAction(title: "Выйти из аккаунта", style: .destructive) {[weak self] _ in
            
            do {
                try Auth.auth().signOut()
                
            } catch {
                print(error.localizedDescription)
            }
            let launchScreenVC = self?.storyboard?.instantiateViewController(withIdentifier: "LaunchScreen")
            
            guard let launchSVC = launchScreenVC else { return }
            
            self?.navigationController?.pushViewController(launchSVC, animated: true)
        }
        let editUserAcc = UIAlertAction(title: "Редактировать аккаунт", style: .default) {[weak self] _ in
            self?.performSegue(withIdentifier: "EditAccountViewController", sender: nil)
        }
        
        actionSheet.addAction(editUserAcc)
        actionSheet.addAction(signOutAcc)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}
