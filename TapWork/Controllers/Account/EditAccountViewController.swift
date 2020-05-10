//
//  EditAccountViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 21/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

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
    
    private var imageOfChanged = false
    private var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateItems()
        
        photoUser.changeStyleImage()
        saveButtonLabel.changeStyleButton(with: "Сохранить")
        
        tappedImagePicker()
        
        navigationItem.title = "Редактировать "
        
        
    }
    
    private func delegateItems() {
        firstNameUser.delegate = self
        lastNameUser.delegate = self
        spezialization.delegate = self
    }
    
    // After tap photo User open image picker
    private func tappedImagePicker() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(setupPhotoUserMenu))
        photoUser.addGestureRecognizer(imageTap)
        photoUser.isUserInteractionEnabled = true
    }
    
    // read data in database by UserID
    private func getDataOfDatabase(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        guard let currentUsers = Auth.auth().currentUser else { return }
        
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
        
        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if error != nil {
                completion(.failure(error!))
                return
                
            } else {
                let firstName = userData["firstName"]
                //                let email = userData["email"]
                let lastName = userData["lastName"]
                let specialization = userData["spezialization"]
                
                self?.firstNameUser.text = firstName as? String
                self?.lastNameUser.text = lastName as? String
                self?.spezialization.text = specialization as? String
                
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
    
    // update Image Profile in Storage and upload in Firestore
    private func updatePhotoUser(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        guard let imageSelected = self.image else {return}
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        let storageRef = Storage.storage().reference(forURL: "gs://tapwork-5c676.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(infoUser.userId)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let uploadTask = storageProfileRef.putData(imageData, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            if percentComplete != 100.0 {
                self.view.activityStartAnimating(activityColor: UIColor.red, backgroundColor: UIColor.black.withAlphaComponent(0.0))
            }
        }
        
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            guard let _ = storageMetaData else {
                completion(.failure(error!))
                return
            }
            
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            storageProfileRef.downloadURL {[weak self] (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    self?.db.collection("users").document(self!.infoUser.userId).updateData([
                        "profileImageUrl": metaImageUrl
                    ])
                    
                    if error != nil {
                        completion(.failure(AuthError.serverError))
                    } else {
                        //                        print("Document successfully updated")
                        completion(.success)
                        
                    }
                }
            }
        }
    }
    
    // update data in FirebaseFirestore by UserID
    private func updateDataTextField(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork() else {
            completion(.failure(AuthError.serverError))
            return
        }
        guard let firstName = firstNameUser.text,
            let lastName = lastNameUser.text,
            let specialization = spezialization.text else {return}
        
        db.collection("users").document(infoUser.userId).updateData([
            "firstName": firstName,
            "lastName": lastName,
            "spezialization": specialization
            ])
        { (error) in
            if error != nil {
                completion(.failure(AuthError.serverError))
            }
            completion(.success)
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        updateDataTextField { (result) in
            switch result {
            case .success:
                self.showAlert(title: "Успешно!", message: "Данные обновлены!")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

//MARK: Text field Delegate
extension EditAccountViewController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: Image Picker
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
        
        if let imageSelected = info[.editedImage] as? UIImage {
            image = imageSelected
            photoUser.image = imageSelected
            photoUser.contentMode = .scaleAspectFill
            photoUser.clipsToBounds = true
        }
        
        if let imageOriginal = info[.originalImage] as? UIImage {
            image = imageOriginal
            photoUser.image = imageOriginal
        }
        dismiss(animated: true)
        
        updatePhotoUser { (result) in
            switch result {
            case .success:
                self.view.activityStopAnimating()
                self.showAlert(title: "Успешно!", message: "Фотография обновлена!")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
                //                self?.showAlert(title: "Ошибка!", message: "Ошибка обновления данных!")
            }
        }
    }
}
