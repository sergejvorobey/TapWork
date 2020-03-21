//
//  EditAccountViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 21/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var firstNameUser: UITextField!
    @IBOutlet weak var lastNameUser: UITextField!
    
    @IBOutlet weak var spezialization: UITextField!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var saveButtonLabel: UIButton!
    
    private var infoUser: Users!
    private var ref: DatabaseReference!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let saveButton = saveButtonLabel {
            saveButton.layer.backgroundColor = UIColor.red.cgColor
            saveButton.layer.cornerRadius = 10
            saveButton.setTitle("Сохранить", for: .normal)
            saveButton.setTitleColor(.white, for: .normal)
        }
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if let error = error {
                print("Error retreiving collection: \(error)")
                self?.alertError(withMessage: "Ошибка при получении данных")
            } else {
                let firstName = userData["firstName"]
                //                let email = userData["email"]
                let lastName = userData["lastName"]
                let specialization = userData["spezialization"]
                
                self?.firstNameUser.text = firstName as? String
                self?.lastNameUser.text = lastName as? String
                self?.spezialization.text = specialization as? String
            }
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        guard let firstName = firstNameUser.text,
            let lastName = lastNameUser.text,
            let specialization = spezialization.text else {return}
        
        db.collection("users").document(infoUser.userId).updateData([
            "firstName": firstName,
            "lastName": lastName,
            "spezialization": specialization
        ]) {[weak self] err in
            if let err = err {
                print("Error updating document: \(err)")
                self?.alertError(withMessage: "Ошибка обновления данных!")
            } else {
                print("Document successfully updated")
                self?.alertError(withMessage: "Данные успешно обновлены!")
            }
        }
    }
}

extension EditAccountViewController {
    
    func alertError(withMessage message: String) {
        
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)/* {[weak self] _ in
            self?.performSegue(withIdentifier: "EditAccountViewController", sender: nil)
        }*/
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}
