//
//  ShowErrorMethod.swift
//  TapWork
//
//  Created by Sergey Vorobey on 07/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

public class ShowError {
    
    func alertError(fromController controller: UIViewController, withMessage message: String) {
        
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Назад", style: .default)
        alertController.addAction(cancel)
        controller.present(alertController, animated: true, completion: nil)
    }
}
