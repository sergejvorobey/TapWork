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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var infoUser: Users!
    private var ref: DatabaseReference!
    private let db = Firestore.firestore()
    var imageOfChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameUser.delegate = self
        lastNameUser.delegate = self
        spezialization.delegate = self
        
        // After tap photo User open image picker
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(setupPhotoUserMenu))
        photoUser.addGestureRecognizer(imageTap)
        photoUser.isUserInteractionEnabled = true
        
        if let saveButton = saveButtonLabel {
            saveButton.layer.backgroundColor = UIColor.red.cgColor
            saveButton.layer.cornerRadius = 10
            saveButton.setTitle("Сохранить", for: .normal)
            saveButton.setTitleColor(.white, for: .normal)
        }
        
        photoUser.image = #imageLiteral(resourceName: "userIcon")
        photoUser.layer.borderWidth = 1
        photoUser.layer.masksToBounds = false
        photoUser.layer.cornerRadius = photoUser.frame.height / 2
        photoUser.clipsToBounds = true
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
    }
    
    //action alert open photo menu (camera,photo library)
    @objc func setupPhotoUserMenu(_ sender: Any) {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Фото", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Назад", style: .destructive) { _ in }
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    // read data in database by UserID
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot,
            
            error in
            
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
    
    //save data in database by UserID
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
        
        let cancel = UIAlertAction(title: "Назад", style: .default)/* {[weak self] _ in
         self?.performSegue(withIdentifier: "EditAccountViewController", sender: nil)
         }*/
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension EditAccountViewController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photoUser.image = info[.editedImage] as? UIImage
        photoUser.contentMode = .scaleAspectFill
        photoUser.clipsToBounds = true
        
        imageOfChanged = true
        
        dismiss(animated: true)
    }
}


