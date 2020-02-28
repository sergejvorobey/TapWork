//
//  AddVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class AddVacansyController: UIViewController {

    
    @IBOutlet weak var headingVacansy: UITextField!
    @IBOutlet weak var categoryButtonLabel: UIButton!
    @IBOutlet weak var descriptionVacansyHeadingLabel: UILabel!
    @IBOutlet weak var contentVacansy: UITextView!
    @IBOutlet weak var paymentVacansy: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var addVacansyLabel: UIButton!
    
    private let maxCountDescriptionTextView = 200
    private let minCountDescriptionTextView = 20
    
    private var ref: DatabaseReference?
    private var user: Users?
    private var vacancies = Array<Vacancy>()
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        ref?.observe(.value) { [weak self] (snapshot) in
            var _vacancies = Array<Vacancy>()
            for item in snapshot.children {
                let vacancy = Vacancy(snapshot: item as! DataSnapshot)
                _vacancies.append(vacancy)
            }
            self?.vacancies = _vacancies
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Добавить вакансию"
        guard let navigation = navigationController else {return}
        navigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 20.0)!
        ]
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        user = Users(user: currentUser)
        
        ref = Database.database().reference(withPath: "vacancies")
       
        headingVacansy.addTarget(self,
                                   action: #selector(addVacansyColorChanged),
                                   for: .editingChanged)
        
        if let categoryButton = categoryButtonLabel {
            categoryButton.setTitle("Категория", for: .normal)
        }
        
        if let headingVacansy = descriptionVacansyHeadingLabel {
            headingVacansy.text = "Описание вакансии"
        }
        
        if let descriptionVacansy = contentVacansy {
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
    
    override func viewDidAppear(_ animated: Bool) {
        headingVacansy.text = ""
        contentVacansy.text = ""
        paymentVacansy.text = ""
        phoneNumber.text = ""
        addVacansyLabel.isEnabled = false
        addVacansyLabel.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func categoryVacansyButton (_ sender: UIButton) {
        
        // MARK: drop-down list of categories
    }
    
    @IBAction func addVacansyButton(_ sender: UIButton) {
        
        let descriptionCount = contentVacansy.text.count

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
        
        guard let headingVacansy = headingVacansy.text,
              let contentVacansy = contentVacansy.text,
              let paymentVacansy = paymentVacansy.text,
              let phoneNumber = phoneNumber.text,
                  headingVacansy != "",
                  contentVacansy != "",
                  paymentVacansy != "",
                  phoneNumber != ""
        
                else { return }
        
        let vacansy = Vacancy(userId: self.user!.userId,
                              heading: headingVacansy ,
                              content: contentVacansy,
                              phoneNumber: phoneNumber,
                              payment: paymentVacansy)

        let vacansyRef = ref?.child(vacansy.heading.lowercased())
        vacansyRef?.setValue(vacansy.providerToDictionary())
        tabBarController?.selectedIndex = 0
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
         
           if headingVacansy.text?.isEmpty == false {
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


