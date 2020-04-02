//
//  RegisterAccountExtensions.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

extension RegisterAccountController {
    
    func alertError(withMessage message: String) {
        
        let alertController = UIAlertController(title: "Ошибка",
                                                message: message,
                                                preferredStyle: .alert)
        
        
        let cancel = UIAlertAction(title: "Назад", style: .default, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension RegisterAccountController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
