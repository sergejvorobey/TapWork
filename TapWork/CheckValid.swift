//
//  CheckValid.swift
//  TapWork
//
//  Created by Sergey Vorobey on 22/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

struct CheckValid {
    
    func alertError(withMessage message: String) {
        
        let alertController = UIAlertController(title: "Ошибка",
                                                message: message,
                                                preferredStyle: .alert)
     
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alertController.addAction(cancel)
        alertController.present(alertController, animated: true, completion: nil)
    }
    
//    func displayWarning(withText text: String) {
//        
////        errorLabel.text = text
//
//        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
////            self?.errorLabel.alpha = 1
//        }) { [weak self] complate in
////            self?.errorLabel.alpha = 0
//        }
//    }
}
