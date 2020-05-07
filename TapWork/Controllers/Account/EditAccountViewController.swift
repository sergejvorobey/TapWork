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
    private let checkNetwork = CheckNetwork()
    private let showAlert = ShowError()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateItems()
        refDatabase()
        photoUser.changeStyleImage()
        saveButtonLabel.changeStyleButton(with: "Сохранить")

        tappedImagePicker()
        
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
    
    private func refDatabase() {
        guard let currentUsers = Auth.auth().currentUser else { return }
        
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
    }
    
    // read data in database by UserID
    private func getDataOfDatabase() {
        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
            
            guard let userData = querySnapshot.data() else {return}
            
            if let error = error {
                print("Error retreiving collection: \(error)")
                self?.showAlert.alertError(fromController: self!, withMessage: "Ошибка при получении данных")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getDataOfDatabase()
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
    private func updatePhotoUser() {
        
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
            
            if percentComplete != 100 {
                self.displaySignUpPendingAlert()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            storageProfileRef.downloadURL {[weak self] (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    self?.db.collection("users").document(self!.infoUser.userId).updateData([
                        "profileImageUrl": metaImageUrl
                    ])
                    
                    if let err = error {
                        print("Error updating document: \(err)")
                        self?.showAlert.alertError(fromController: self!, withMessage: "Ошибка обновления данных!")
                    } else {
                        print("Document successfully updated")
                        // self?.alertError(withMessage: "Данные успешно обновлены!")
                        // self?.displaySignUpPendingAlert()
                    }
                }
            }
        }
    }
    
    // update data in FirebaseFirestore by UserID
    private func updateData() {
        
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
                self?.showAlert.alertError(fromController: self!, withMessage: "Ошибка обновления данных!")
            } else {
                print("Document successfully updated")
                self?.showAlert.alertError(fromController: self!, withMessage: "Данные успешно обновлены!")
            }
        }
    }
    
    //check to network connected
    @IBAction func savePressed(_ sender: UIButton) {
        
        if checkNetwork.isConnectedToNetwork(){
            print("Internet Connection Available!")
            updateData()
        } else {
            print("Internet Connection not Available!")
            showAlert.alertError(fromController: self, withMessage: "Ошибка интернет соединения!")
        }
    }
    
    // alert with progress update Image in Firebase
    private func displaySignUpPendingAlert()  {
        
        //create an alert controller
        let alert = UIAlertController(title: "Загрузка", message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
        
        present(alert, animated: true)
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
            
            imageOfChanged = true
        }
        
        if let imageOriginal = info[.originalImage] as? UIImage {
            image = imageOriginal
            photoUser.image = imageOriginal
            
            imageOfChanged = true
        }
            dismiss(animated: true)
        if checkNetwork.isConnectedToNetwork() {
            print("Internet Connection Available!")
            updatePhotoUser()
        } else {
            print("Internet Connection not Available!")
            showAlert.alertError(fromController: self, withMessage: "Ошибка загрузки фотографии, проверьте интернет!")
        }
    }
}

