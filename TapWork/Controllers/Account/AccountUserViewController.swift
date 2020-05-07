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
    private var image = #imageLiteral(resourceName: "userImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUser.changeStyleImage()
        refDatabase()
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        guard let topItem = navigationController?.navigationBar.topItem else {return}
        topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                    style: .plain,
                                                    target: nil, action: nil)
    }
    
    private func refDatabase() {
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
    }
    
    private func getDataOfDatabase() {
        let db = Firestore.firestore()
        
        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if let error = error {
                print("Error retreiving collection: \(error)")
            } else {
                guard let firstName = userData["firstName"],
                    let email = userData["email"],
                    let lastName = userData["lastName"],
                    let specialization = userData["spezialization"],
                    let profileImage = userData["profileImageUrl"] as? String  else {return}
                
                let fullName = """
                \(firstName)
                \(lastName)
                """
                self?.nameUserLabel.text = fullName
                self?.emailUserLabel.text = email as? String
                self?.specializationUserLabel.text = "Профессия: \(specialization)"
                
                if profileImage == "" {
                    self?.imageUser.image = self?.image
                } else if let url = URL(string: profileImage) {
                    self?.imageUser.loadImage(from: url)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDataOfDatabase()
    }
    
    private func showMenu() {
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
    
    @IBAction func menuAccount(_ sender: UIBarButtonItem) {
        showMenu()
    }
}


