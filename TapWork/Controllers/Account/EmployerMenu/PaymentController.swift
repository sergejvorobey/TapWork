//
//  PaymentController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class PaymentController: UIViewController {
    
    @IBOutlet weak var headerSectionLabel: UILabel!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var summaryCountLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var messagePhoneLabel: UILabel!
    @IBOutlet weak var switchShowPhone: UISwitch!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintSwitch: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        checkShowPhone()
    }
    
    private func setupItems() {
        changeFrameKeyboard()
        headerSectionLabel.text = "Бюджет и телефон"
        nextButtonLabel.changeStyleButton(with: "Далее")
        errorLabel.isHidden = true
        paymentTextField.delegate = self
        phoneTextField.delegate = self
        messagePhoneLabel.text = "Указывать телефон"
    }
    
    private func checkShowPhone() {
        
        if switchShowPhone.isOn {
            
            messagePhoneLabel.text = "Указывать телефон"
            
            self.bottomConstraintSwitch.constant = 80
            
            UIView.animate(withDuration: 0.5) {
                self.phoneTextField.isHidden = false
                self.view.layoutIfNeeded()
            }
        } else {
            messagePhoneLabel.text = "Не указывать телефон"
            
            self.bottomConstraintSwitch.constant = 10
            
            UIView.animate(withDuration: 0.5) {
                self.phoneTextField.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // When the keyboard appears, indent from the keyboard to the buttons
    private func changeFrameKeyboard() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PaymentController: UITextFieldDelegate {
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
