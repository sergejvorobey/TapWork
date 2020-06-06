//
//  Extension + UIViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func errorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func successAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func disMissController() {
        let alert = UIAlertController(title: "Все что вы заполнили, будет сброшено",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Сбросить и выйти", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
