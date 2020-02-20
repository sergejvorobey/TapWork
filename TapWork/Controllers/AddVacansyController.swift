//
//  AddVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class AddVacansyController: UIViewController {

    
    @IBOutlet weak var nameVacansy: UITextField!
    @IBOutlet weak var categoryButtonLabel: UIButton!
    @IBOutlet weak var descriptionVacansyHeadingLabel: UILabel!
    @IBOutlet weak var descriptionVacansyTextView: UITextView!
    @IBOutlet weak var budgetVacansy: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var addVacansyLabel: UIButton!
    
    private let maxCountDescriptionTextView = 200
    private let minCountDescriptionTextView = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nameVacansy.addTarget(self,
                                   action: #selector(addVacansyColorChanged),
                                   for: .editingChanged)
        
       
        
        if let categoryButton = categoryButtonLabel {
            categoryButton.setTitle("Категория", for: .normal)
        }
        
        if let headingVacansy = descriptionVacansyHeadingLabel {
            headingVacansy.text = "Описание вакансии"
        }
        
        if let descriptionVacansy = descriptionVacansyTextView {
            descriptionVacansy.text = ""
            descriptionVacansy.layer.borderWidth = 1
            descriptionVacansy.layer.cornerRadius = 10
        }
        
        if let addButton = addVacansyLabel {
            addButton.isEnabled = false
            addButton.layer.backgroundColor = UIColor.lightGray.cgColor
            addButton.layer.cornerRadius = 10
            addButton.setTitle("Добавить вакансию", for: .normal)
            addButton.setTitleColor(.white, for: .normal)
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
    
    
    @IBAction func categoryVacansyButton (_ sender: UIButton) {
        
        // MARK: drop-down list of categories
    }
    
    @IBAction func addVacansyButton(_ sender: UIButton) {
        
        let descriptionCount = descriptionVacansyTextView.text.count
        
        switch descriptionCount {
            // MARK: Up to work conditions
        case _ where descriptionCount > maxCountDescriptionTextView :
            print("слишком большое описание")
        case _ where descriptionCount < minCountDescriptionTextView :
            print("слишком короткое описание")
        case _ where descriptionCount < maxCountDescriptionTextView &&
            descriptionCount > minCountDescriptionTextView :
            print("norm")
        default:
            break
        }
    }
}

extension AddVacansyController: UITextFieldDelegate, UITextViewDelegate {
    
    // скрываем клавиатуру при нажатии на Done
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    // изменяем цвет кнопки при заполнии данных в nameVacansy
       @objc private func addVacansyColorChanged () {
         
           if nameVacansy.text?.isEmpty == false {
                addVacansyLabel.isEnabled = true
                addVacansyLabel.layer.backgroundColor = UIColor.red.cgColor
           } else {
                addVacansyLabel.isEnabled = false
                addVacansyLabel.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
    // скрываем клавиатуру при нажатии на Done
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if(text == "\n") {
                textView.resignFirstResponder()
                return false
        }
        return true
    }
}


