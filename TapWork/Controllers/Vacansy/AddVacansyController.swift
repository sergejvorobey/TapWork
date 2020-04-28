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
    @IBOutlet weak var cityButtonLabel: UIButton!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
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
    let disclosureCity = UITableViewCell()
    let disclosureCategory = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = ""
        categoryLabel.text = ""

        settingLabelAndButton()
        
        self.addDoneButtonOnNumberKeyboard()
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        user = Users(user: currentUser)
        
        ref = Database.database().reference(withPath: "vacancies")
        
        headingVacansy.addTarget(self,
                                 action: #selector(addVacansyColorChanged),
                                 for: .editingChanged)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        contentVacansy.checkPlaceholder()
    }
    
    // изменяем цвет кнопки при заполнении данных в nameVacansy
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
        
//         contentVacansy.text = ""
//         contentVacansy.setPlaceholder(with: "Максимально 200 символов")
        
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
        super.viewDidAppear(true)
       
        if contentVacansy.text.isEmpty == true {
            contentVacansy.checkPlaceholder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        contentVacansy.text = ""
        headingVacansy.text = ""
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
    
    @IBAction func cityVacansyButton(_ sender: UIButton) {
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
//            print("all right")
            let vacansy = Vacancy(userId: self.user!.userId,
                                  heading: headingVacansy ,
                                  content: contentVacansy,
                                  phoneNumber: phoneNumber,
                                  payment: paymentVacansy)
            
            let vacansyRef = ref?.child(vacansy.heading)
            vacansyRef?.setValue(vacansy.providerToDictionary())
            alertMessage(withMessage: "Ваша вакансия опубликована!")
        default:
            break
        }
    }
}

extension AddVacansyController {
    
    func settingLabelAndButton() {
         
        navigationItem.title = "Cоздать вакансию"
        
//        guard let navigation = navigationController else {return}
//        
//        navigation.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.red,
//            NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 20.0)!
//        ]
        
        guard let categoryButton = categoryButtonLabel, let cityButton = cityButtonLabel else {return}
        
        categoryButton.setTitle("Выберите категорию:", for: .normal)
        cityButton.setTitle("Выберите город:", for: .normal)
        
        disclosureCategory.frame = categoryButton.bounds
        disclosureCity.frame = cityButton.bounds
        disclosureCategory.accessoryType = .disclosureIndicator
        disclosureCity.accessoryType = .disclosureIndicator
        disclosureCategory.isUserInteractionEnabled = false
        disclosureCity.isUserInteractionEnabled = false
        
        categoryButton.layer.cornerRadius = 10
        categoryButton.layer.borderWidth = 0.5
        categoryButton.layer.masksToBounds = true
        
        cityButton.layer.cornerRadius = 10
        cityButton.layer.borderWidth = 0.5
        cityButton.layer.masksToBounds = true
        
        categoryButton.addSubview(disclosureCategory)
        cityButton.addSubview(disclosureCity)
        
        guard let headingVacansy = descriptionVacansyHeadingLabel else  {return}
            headingVacansy.text = "Описание вакансии"
 
        guard let addButton = addVacansyLabel else {return}
            addButton.isEnabled = false
            addButton.layer.backgroundColor = UIColor.lightGray.cgColor
            addButton.layer.cornerRadius = 10
            addButton.setTitle("Добавить вакансию", for: .normal)
            addButton.setTitleColor(.white, for: .normal)
        
        guard let city = cityLabel, let category = categoryLabel else {return}

        city.styleLabel(with: " Город не выбран ")
        category.styleLabel(with: " Категория не выбрана ")
        
        guard let content = contentVacansy else {return}

        content.layer.borderWidth = 0.5
        content.layer.cornerRadius = 10
        content.delegate = self
        content.text = ""
        content.setPlaceholder(with: "Максимально 200 символов")
        
    }
}

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
//            self?.tabBarController?.selectedIndex = 0
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
            
//            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 50, right: 0)
            
        } else {
            
//            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 - keyboardFrame.height, right: 0)
        }
    }
}


