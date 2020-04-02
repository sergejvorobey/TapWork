//
//  AddVacansyControllerExtensions.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

extension AddVacansyController: UITextFieldDelegate, UITextViewDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // hide the keyboard when you click on Done text View
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // alert message after successful added vacansy
    func alertMessage(withMessage message: String) {
        
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Назад", style: .default) {[weak self] _ in
            self?.tabBarController?.selectedIndex = 0
        }
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // alert message after check error
    func alertError(withMessage message: String) {
           
           let alertController = UIAlertController(title: "",
                                                   message: message,
                                                   preferredStyle: .alert)
           
           let cancel = UIAlertAction(title: "Назад", style: .default) 
           alertController.addAction(cancel)
           present(alertController, animated: true, completion: nil)
       }
    
    // keyboard hide and show
    @objc func updateChangeFrame (notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 50, right: 0)
            
        } else {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 - keyboardFrame.height, right: 0)
        }
    }
}
