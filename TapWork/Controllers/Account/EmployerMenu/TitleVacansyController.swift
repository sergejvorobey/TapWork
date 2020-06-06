//
//  TitleVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import iOSDropDown

class TitleVacansyController: UIViewController {
    
    @IBOutlet weak var headerSection: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var cityDropMenuTxtFld: DropDown!
    @IBOutlet weak var summaryCountLbl: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var citiesList = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupItems()
        loadCitiesData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        hideController()
    }
    
    private func setupItems() {
        delegates()
//        nextButtonLabel.addShadow()
        nextButtonLabel.changeStyleButton(with: "Далее")
        updateCharacterCount()
        changeFrameKeyboard()
        headerSection.text = "Название и город"
        errorLabel.isHidden = true
        titleTextField.placeholder = "Название"
        cityDropMenuTxtFld.placeholder = "Город"
        
    }
    
    private func delegates() {
        titleTextField.delegate = self
        cityDropMenuTxtFld.delegate = self
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        checkTextFields(title: titleTextField.text, city: cityDropMenuTxtFld.text) { (result) in
            switch result {
            case .success:
                self.performSegue(withIdentifier: "contentVacansyController", sender: nil)
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        //MARK: hide controller
        self.disMissController()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contentVacansyController" {
            let contentVC = segue.destination as! ContentVacansyController
            contentVC.header = titleTextField.text!
            contentVC.city = cityDropMenuTxtFld.text!
        }
    }
    
    //MARK: checking texts fields for errors
    private func checkTextFields(title: String? ,city: String?, completion: @escaping (AuthResult) -> Void) {
        guard Validators.isFilledMultipleTextFields(firstText: title, secondText: city)
            else {
                completion(.failure(AuthError.notFilled))
                return
        }
        guard Validators.checkLengthField(text: title, minCount: 5, maxCount: 30)
            else {
            completion(.failure(AuthError.lenghtTitle))
            return
        }
        completion(.success)
    }
}

//MARK: Text Field Delegate
extension TitleVacansyController: UITextFieldDelegate {
    
    func updateCharacterCount() {
        self.summaryCountLbl.text = "\((0))/30 (мин. 5)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 16 characters
        self.summaryCountLbl.text = "\((0) + updatedText.count)/30 (мин. 5)"
        
        //MARK: TODO
        if updatedText.count < 5 {
            errorLabel.isHidden = false
            errorLabel.textColor = .red
            errorLabel.text = "Название слишком короткое"
        } else {
            errorLabel.isHidden = true
        }
        return updatedText.count <= 29
    }
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cityDropMenuTxtFld {
             return false
        }
       return true
    }
}

//MARK: Get data in Firebase
extension TitleVacansyController {
    
    private func loadCitiesData() {
        
        let dataLoader = CitiesLoaderAPI()
        dataLoader.getAllCitiesName()
        
        dataLoader.completionHandler { [weak self] (cities, status, message) in
            
            if status {
                guard let self = self else {return}
                guard let _cities = cities else {return}
                
                self.citiesList = _cities
                
                var arrayCities = [String]()
                
                for city in self.citiesList {
                    arrayCities.append(city.title!)
                    self.cityDropMenuTxtFld.optionArray = arrayCities
                    
                }
            }
        }
    }
}

//MARK: For keyboard show or hide
extension TitleVacansyController {
    
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
}
