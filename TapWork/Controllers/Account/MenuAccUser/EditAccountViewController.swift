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
    
    @IBOutlet weak var roleUserLabel: UILabel!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstNameUser: UITextField!
    @IBOutlet weak var lastNameUser: UITextField!
    @IBOutlet weak var birthUser: UITextField!
//    @IBOutlet weak var spezialization: UITextField!

    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var user: CurrentUser?
    
//    private var infoUser: Users!
//    private var ref: DatabaseReference!
    private let db = Firestore.firestore()
    private var image: UIImage? = nil

//    private var userData = [CurrentUser]()
//    private var userStatus: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStyleItems()
       
    }
    
    private func setupBirthPicker() {
           self.birthUser.setInputViewDatePicker(target: self, selector: #selector(tapDone))
       }
       
       @objc func tapDone() {
           if let datePicker = self.birthUser.inputView as? UIDatePicker { // 2-1
               let dateFormatter = DateFormatter() // 2-2
               dateFormatter.dateStyle = .medium // 2-3
               dateFormatter.locale = Locale(identifier: "ru_RU")
               self.birthUser.text = dateFormatter.string(from: datePicker.date) //2-4
           }
           self.birthUser.resignFirstResponder() // 2-5
       }
    
    private func changeStyleItems() {
        
        delegateItems()
        photoUser.changeStyleImage()
        tappedImagePicker()
        setupBirthPicker()
        saveButtonLabel.changeStyleButton(with: "Сохранить")
        navigationItem.title = "Редактировать"
        
        roleSegmentedControl.setTitle("Соискатель", forSegmentAt: 0)
        roleSegmentedControl.setTitle("Работодатель", forSegmentAt: 1)
        
    }
    
    private func delegateItems() {
        firstNameUser.delegate = self
        lastNameUser.delegate = self
//        spezialization.delegate = self
    }
    
    // After tap photo User open image picker
    private func tappedImagePicker() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(setupPhotoUserMenu))
        photoUser.addGestureRecognizer(imageTap)
        photoUser.isUserInteractionEnabled = true
    }
    
    // read data in database by UserID
//    private func getDataOfDatabase(completion: @escaping (AuthResult) -> Void) {
//
//        guard Validators.isConnectedToNetwork()  else {
//            completion(.failure(AuthError.serverError))
//            return
//        }
//        guard let currentUsers = Auth.auth().currentUser else { return }
//
//        infoUser = Users(user: currentUsers)
//        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
//
//        db.collection("users").document(infoUser.userId).addSnapshotListener {[weak self] querySnapshot, error in
//
//            guard let querySnapshot = querySnapshot, querySnapshot.exists else {return}
//
//            guard let userData = querySnapshot.data() else {return}
//
//            if error != nil {
//                completion(.failure(error!))
//                return
//
//            } else {
//                let firstName = userData["firstName"] as? String
//                //                let email = userData["email"]
//                let lastName = userData["lastName"] as? String
////                let specialization = userData["spezialization"] as? String
//                let roleUser = userData["roleUser"] as? String
////                let birth = userData["birth"] as? String
//
//                self?.firstNameUser.text = firstName
//                self?.lastNameUser.text = lastName
////                self?.spezialization.text = specialization
////                self?.birthDayButtonLabel.setTitle(birth, for: .normal)
//                self?.roleUserLabel.text = roleUser
//
//                if roleUser == "Соискатель"  {
//                    self?.roleSegmentedControl.selectedSegmentIndex = 0
//                    self?.roleUserLabel.textColor = .red
//                } else {
//                    self?.roleSegmentedControl.selectedSegmentIndex = 1
//                    self?.roleUserLabel.textColor = .blue
//                }
//            }
//            completion(.success)
//        }
//    }
    
    // get data in database by UserID
//    private func getCurrentUserData(completion: @escaping (AuthResult) -> Void) {
//
//        guard Validators.isConnectedToNetwork()  else {
//            completion(.failure(AuthError.serverError))
//            return
//        }
//
//        let dataLoader = LoaderUserData()
//        dataLoader.refDatebase()
//
//        dataLoader.completionHandler { [weak self] (user, status, message) in
//
//            if status {
//                guard let self = self else {return}
//                guard let _user = user else {return}
//                self.userData = _user
//
//                for user in self.userData {
//                    self.firstNameUser.text = user.firstName
//                    self.lastNameUser.text = user.lastName
//                    //                self?.spezialization.text = specialization
////                    let userBirth = user.birth
////                    self.birthDayButtonLabel.setTitle(user.birth, for: .normal)
//                    self.roleUserLabel.text = user.roleUser
//
//                    if user.roleUser == "Соискатель"  {
//                        self.roleSegmentedControl.selectedSegmentIndex = 0
//                        self.roleUserLabel.textColor = .red
//                    } else {
//                        self.roleSegmentedControl.selectedSegmentIndex = 1
//                        self.roleUserLabel.textColor = .blue
//                    }
//                }
//            }
//        }
//        completion(.success)
//    }
    
    // get data in database by UserID
    private func getDataUserProfile(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
                   completion(.failure(AuthError.serverError))
                   return
               }
        
        guard let userData = user else {return}
        
        for data in [userData] {
            self.firstNameUser.text = data.firstName
            self.lastNameUser.text = data.lastName
            self.roleUserLabel.text = data.roleUser
            self.birthUser.text = data.birth
            
            if data.roleUser == "Соискатель" {
                self.roleSegmentedControl.selectedSegmentIndex = 0
                self.roleUserLabel.textColor = .red
            } else {
                self.roleSegmentedControl.selectedSegmentIndex = 1
                self.roleUserLabel.textColor = .blue
            }
        }
        completion(.success)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getDataUserProfile { (result) in
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
        let storageProfileRef = storageRef.child("profile").child(user!.uid!)
        
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
                    
                    self?.db.collection("users").document(self!.user!.uid!).updateData([
                        "profileImageUrl": metaImageUrl
                    ])
                    
                    if error != nil {
                        completion(.failure(AuthError.serverError))
                    } else {
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
//            let specialization = spezialization.text,
            let roleUser = roleUserLabel.text,
            let birth = birthUser.text else {return}

        db.collection("users").document(user!.uid!).updateData([
            "firstName": firstName,
            "lastName": lastName,
//            "spezialization": specialization,
            "birth": birth,
            "roleUser": roleUser
            ])
        { (error) in
            if error != nil {
                completion(.failure(AuthError.unknownError))
            }
            completion(.success)
        }
    }
    
    @IBAction func segmentRoleSelection(_ sender: UISegmentedControl) {
        switch roleSegmentedControl.selectedSegmentIndex {
            case 0:
                roleUserLabel.text = roleSegmentedControl.titleForSegment(at: 0)
            roleUserLabel.textColor = .red
            case 1:
            roleUserLabel.text = roleSegmentedControl.titleForSegment(at: 1)
            roleUserLabel.textColor = .blue
        default:
            break
        }
    }
    
   
    
  
    
    //update data 
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


