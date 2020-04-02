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
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let maxCountDescriptionTextView = 200
    private let minCountDescriptionTextView = 20
    
    private var ref: DatabaseReference?
    private var user: Users?
    private var vacancies = Array<Vacancy>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDoneButtonOnNumberKeyboard()
        
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        headingVacansy.text = ""
        contentVacansy.text = ""
        paymentVacansy.text = ""
        phoneNumber.text = ""
        addVacansyLabel.isEnabled = false
        addVacansyLabel.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    // MARK: Done button on numberKeyboard
    func addDoneButtonOnNumberKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil,
                                        action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: UIBarButtonItem.Style.done,
                                                    target: self,
                                                    action: #selector(doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = (items as! [UIBarButtonItem])
        doneToolbar.sizeToFit()
        
        self.phoneNumber.inputAccessoryView = doneToolbar
        self.paymentVacansy.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.phoneNumber.resignFirstResponder()
        self.paymentVacansy.resignFirstResponder()
    }
    
    @IBAction func categoryVacansyButton (_ sender: UIButton) {
        
        // MARK: drop-down list of categories
    }
    
    @IBAction func addVacansyButton(_ sender: UIButton) {
        
        guard let headingVacansy = headingVacansy.text,
            let contentVacansy = contentVacansy.text,
            let paymentVacansy = paymentVacansy.text,
            let phoneNumber = phoneNumber.text,
            headingVacansy != "",
            contentVacansy != "",
            paymentVacansy != "",
            phoneNumber != ""
            
            else {
                alertError(withMessage: "Пожалуйста, заполните все поля!")
                return
        }
        
         // check valid data in text field
        let content = contentVacansy.count
       
        switch content {
            
        case _ where content > maxCountDescriptionTextView :
            alertError(withMessage: "Cлишком большое описание, максимальное количество символов: 200")
        case _ where content < minCountDescriptionTextView :
            alertError(withMessage: "Слишком короткое описание, минимальное количество символов: 20")
        case _ where content < maxCountDescriptionTextView &&
            content > minCountDescriptionTextView :
            print("all right")
            let vacansy = Vacancy(userId: self.user!.userId,
                                  heading: headingVacansy ,
                                  content: contentVacansy,
                                  phoneNumber: phoneNumber,
                                  payment: paymentVacansy)

            let vacansyRef = ref?.child(vacansy.userId)
            vacansyRef?.setValue(vacansy.providerToDictionary())
            alertMessage(withMessage: "Ваша вакансия опубликована!")
        default:
            break
        }
    }
}




