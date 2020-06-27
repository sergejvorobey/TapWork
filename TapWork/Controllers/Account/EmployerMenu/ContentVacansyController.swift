//
//  ContentVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ContentVacansyController: UIViewController {
    
    @IBOutlet weak var headerSectionLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var summaryCountLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var header: String?
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupItems()
    }

    private func setupItems() {
        delegates()
        keyboardObserver()
        nextButtonLabel.addShadow()
        updateCharacterCount()
        nextButtonLabel.changeStyleButton(with: "Далее")
        headerSectionLabel.text = "Описание"
        errorLabel.isHidden = true
        contentTextView.addCorner()
        contentTextView.addShadow()
//        contentTextView.layer.cornerRadius = 10
        contentTextView.setPlaceholder(with: "Описание вакансии")
        contentTextView.becomeFirstResponder()
    }
    
    private func delegates() {
        contentTextView.delegate = self
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        checkTextFields(text: contentTextView.text) { (result) in
            switch result {
            case .success:
                self.performSegue(withIdentifier: "paymentController", sender: nil)
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        //MARK: hide controller
        self.disMissController()
    }
    
    func updateCharacterCount() {
        self.summaryCountLabel.text = "\((0))/200 (мин. 20)"
    }
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentController" {
            let paymentVC = segue.destination as! PaymentController
            paymentVC.headerVacansy = header
            paymentVC.cityVacansy = city
            paymentVC.contentVacansy = contentTextView.text
            
        }
    }
    
    //MARK: checking texts fields for errors
    private func checkTextFields(text: String?, completion: @escaping (AuthResult) -> Void) {
        guard Validators.isFilledTextField(text: text) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard Validators.checkLengthField(text: text, minCount: 20, maxCount: 200)
            else {
            completion(.failure(AuthError.lenghtContent))
            return
        }
        completion(.success)
    }
}

//MARK: Text View Delegate
extension ContentVacansyController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
          self.updateCharacterCount()
      }
      
      func textViewDidChange(_ textView: UITextView) {
          contentTextView.checkPlaceholder()
      }

    // hide the keyboard when you click on Done text View
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        self.summaryCountLabel.text = "\((0) + updatedText.count)/200 (мин. 20)"
        
        //MARK: TODO
        if updatedText.count < 20 {
            errorLabel.isHidden = false
            errorLabel.textColor = .red
            errorLabel.text = "Описание слишком короткое"
        } else {
            errorLabel.isHidden = true
        }
        return updatedText.count <= 199
    }
}

//MARK: For keyboards
extension ContentVacansyController {
    
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
