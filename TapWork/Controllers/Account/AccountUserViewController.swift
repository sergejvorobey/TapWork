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

    @IBOutlet weak var ratingLabel: UILabel!
    
//    private var currentUser = Array<CurrentUser>()
    private var roleUserString = ""
    
    private var infoUser: Users!
    private var ref: DatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStyleItems()
//        refDatebase()

    }
    
    // test method
//    private func refDatebase()  {
//
//        guard let currentUsers = Auth.auth().currentUser else { return }
//        infoUser = Users(user: currentUsers)
//        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
//
//        let db = Firestore.firestore()
//        db.collection("users").document(infoUser.userId).addSnapshotListener { (snapshot, _) in
//
//            let data = snapshot?.data()
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
//                let user = try JSONDecoder().decode(CurrentUser.self, from: jsonData)
////                print(user)
//                self.currentUser = [user]
//                print(self.currentUser)
//            }
//            catch {
//
//            }
//        }
//    }
    
    private func changeStyleItems() {
        
        setupNavigationBar()
        imageUser.changeStyleImage()

        ratingLabel.text = "Рейтинг: Вне рейтинга" //TODO
        
    }
    
    private func setupNavigationBar() {
        guard let topItem = navigationController?.navigationBar.topItem else {return}
        topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                    style: .plain,
                                                    target: nil, action: nil)
    }
    
    private func getDataOfDatabase(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        guard let currentUsers = Auth.auth().currentUser else { return }
               infoUser = Users(user: currentUsers)
               ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
        
        let db = Firestore.firestore()
        
        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if error != nil {
                completion(.failure(error!))
            } else {
                guard let firstName = userData["firstName"],
                    let email = userData["email"],
                    let lastName = userData["lastName"],
                    let specialization = userData["spezialization"],
                    let profileImage = userData["profileImageUrl"] as? String,
                    let roleUser = userData["roleUser"] as? String else {return}
                
                self?.roleUserString = roleUser
                
                let fullName = """
                \(firstName)
                \(lastName)
                """
                self?.nameUserLabel.text = fullName
                self?.emailUserLabel.text = email as? String
                self?.specializationUserLabel.text = "Профессия: \(specialization)"
                
                if profileImage != "" {
                    let url = URL(string: profileImage)
                    ImageService.getImage(withURL: url!) { (image) in
                        self?.imageUser.image = image
                    }
                }
            }
            completion(.success)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDataOfDatabase { (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    private func alertMenu() {
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
        let editUserAcc = UIAlertAction(title: "Редактировать аккаунт", style: .default) { _ in
            self.performSegue(withIdentifier: "EditAccountViewController", sender: nil)
        }
        let profDataUser = UIAlertAction(title: "Обо мне", style: .default) { _ in
            self.performSegue(withIdentifier: "ProfDataUserController", sender: nil)
        }
        let forEmployer = UIAlertAction(title: "Для работодателя", style: .default) { _ in
            self.performSegue(withIdentifier: "EmployerCollectionController", sender: nil)
        }
        
        actionSheet.addAction(editUserAcc)
        actionSheet.addAction(profDataUser)
        
        if self.roleUserString == "Работодатель" {
            actionSheet.addAction(forEmployer)
        }
       
        actionSheet.addAction(signOutAcc)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    @IBAction func menuAccount(_ sender: UIBarButtonItem) {
        alertMenu()
    }
}


