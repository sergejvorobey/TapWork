//
//  AdditionaInfolUserController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class AdditionaInfolUserController: UIViewController {
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var summaryCountLbl: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBar: UINavigationBar!
    
    private let db = Firestore.firestore()
    private let aboutMeKey = "Не указано"
    var aboutMeText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkText()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func checkText() {
        
//        print(aboutMeText)
//        if aboutMeText == aboutMeKey {
//            aboutMeTextView.setPlaceholder(with: "Есть еще что-нибудь, что стоит рассказать?")
//        } else {

            aboutMeTextView.text = aboutMeText
//        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        updateAboutMeData(text: aboutMeTextView.text) { (result) in
            switch result {
            case .success:
                self.successAlert(title: "Успешно!", message: "Данные обновлены!")
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    //MARK: setup items
    private func setupItems() {
        updateCharacterCount()
        navBar.topItem?.title = "О себе"
        saveButtonLabel.changeStyleButton(with: "Сохранить")
        aboutMeTextView.addCorner()
        aboutMeTextView.addShadow()
        keyboardObserver()
        aboutMeTextView.delegate = self
//        checkText()
//        aboutMeTextView.setPlaceholder(with: "Есть еще что-нибудь, что стоит рассказать?")
        aboutMeTextView.becomeFirstResponder()
    }
}

//MARK: keyboard hide/show
extension AdditionaInfolUserController {
    
    private func keyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // keyboard hide and show
    @objc func updateChangeFrame (notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            
            self.bottomConstraint.constant = keyboardFrame.height + 5
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            self.bottomConstraint.constant = 20
            
            UIView.animate(withDuration: 0.25) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
}

//MARK: Text View Delegate
extension AdditionaInfolUserController: UITextViewDelegate {
    
    func updateCharacterCount() {
        guard let summaryCount = aboutMeText?.count else {return}
        self.summaryCountLbl.text = "\(summaryCount)/200"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        aboutMeTextView.checkPlaceholder()
    }
    
    //MARK: counter for keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        self.summaryCountLbl.text = "\((0) + updatedText.count)/200"
        
        return updatedText.count <= 199
    }
}

//MARK: update date in firebase
extension AdditionaInfolUserController {
    
    private func updateAboutMeData(text: String?, completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        //MARK: check field filled
//        guard Validators.isFilledTextField(text: text) else {
//            completion(.failure(AuthError.notFilled))
//            return
//        }
        guard let text = text
            else {
                completion(.failure(AuthError.unknownError))
                return
        }
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        let infoUser = Users(user: currentUsers)
        
        db.collection("users")
            .document(infoUser.userId)
            .collection("userData")
            .document("profession")
            .updateData([
                "aboutMe": text
                ])
            { (error) in
                if error != nil {
                    completion(.failure(AuthError.unknownError))
                }
                completion(.success)
        }
    }
}
