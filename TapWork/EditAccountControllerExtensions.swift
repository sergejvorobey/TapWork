//
//  EditAccountControllerExtensions.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

extension EditAccountViewController {
    
    func alertError(withMessage message: String) {
        
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Назад", style: .default)/* {[weak self] _ in
         self?.performSegue(withIdentifier: "EditAccountViewController", sender: nil)
         }*/
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension EditAccountViewController: UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

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
        
        photoUser.image = info[.editedImage] as? UIImage
        photoUser.contentMode = .scaleAspectFill
        photoUser.clipsToBounds = true
        
        imageOfChanged = true
        
        dismiss(animated: true)
    }
}

