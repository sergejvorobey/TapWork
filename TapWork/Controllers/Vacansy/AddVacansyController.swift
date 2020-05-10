//
//  AddVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown

class AddVacansyController: UIViewController {
    
    @IBOutlet weak var headingVacansy: UITextField!
    @IBOutlet weak var categoryButtonLabel: UIButton!
    @IBOutlet weak var dropDownCities: DropDown!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionVacansyHeadingLabel: UILabel!
    @IBOutlet weak var contentVacansy: UITextView!
    @IBOutlet weak var paymentVacansy: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var addVacansyLabel: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var citiesList = [Items]()
    
    private var ref: DatabaseReference?
    private var user: Users?
    private var vacancies = Array<Vacancy>()
    
//    let disclosureCategory = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseData()
        settingLabelAndButton()
        addDoneButtonOnNumberKeyboard()
        
        observerKeyboard()
        
    }
    
    private func observerKeyboard() {
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        contentVacansy.checkPlaceholder()
    }
    
    
    private func getDataDatabase(completion: @escaping (AuthResult) -> Void) {
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
        ref = Database.database().reference(withPath: "vacancies")
        
        ref?.observe(.value) { [weak self] (snapshot) in
            var _vacancies = Array<Vacancy>()
            for item in snapshot.children {
                let vacancy = Vacancy(snapshot: item as! DataSnapshot)
                _vacancies.append(vacancy)
            }
            self?.vacancies = _vacancies
        }
        completion(.success)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataDatabase { (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
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
        dropDownCities.text = ""
        cityLabel.text = " не выбран "
        paymentVacansy.text = ""
        phoneNumber.text = ""
        //        addVacansyLabel.isEnabled = false
        //        addVacansyLabel.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    // MARK: Done button on numberKeyboard
    private func addDoneButtonOnNumberKeyboard() {
        
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
        performSegue(withIdentifier: "CategoriesController", sender: nil)
    }
    
    // MARK: Add vacansy method in database
    private func addVacansy(heading: String?,
                            content: String?,
                            payment: String?,
                            phone: String?,
                            completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        
        guard Validators.isFilledVacansy(headingVacansy: headingVacansy.text,
                                         contentVacansy: contentVacansy.text,
                                         paymentVacansy: paymentVacansy.text,
                                         phoneNumber: phoneNumber.text)
            else {
                completion(.failure(AuthError.notFilled))
                return
        }
        
        guard let heading = heading,
            let content = content,
            let payment = payment,
            let phone = phone
            else {
                completion(.failure(AuthError.unknownError))
                return
        }
        
        guard Validators.checkLengthFiedls(headingVacansy: heading, contentVacansy: content, paymentVacansy: payment, phoneNumber: phone) else {
            completion(.failure(AuthError.lengthFiedls))
            return
        }
        let vacansy = Vacancy(userId: self.user!.userId,
                              heading: heading ,
                              content: content,
                              phoneNumber: phone,
                              payment: payment)
        let vacansyRef = ref?.child(vacansy.heading)
        vacansyRef?.setValue(vacansy.providerToDictionary())
        
        completion(.success)
    }
    
    @IBAction func addVacansyButton(_ sender: UIButton) {
        
        addVacansy(heading: headingVacansy.text,
                   content: contentVacansy.text,
                   payment: paymentVacansy.text,
                   phone: phoneNumber.text)
        { (result) in
            switch result {
                
            case .success:
                self.showAlert(title: "Успешно!", message: "Вакансия опубликована!")
//                self.dismiss(animated: true, completion: nil)
                self.tabBarController?.selectedIndex = 0
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
           
            }
        }
    }
}

extension AddVacansyController {
    
    private func settingLabelAndButton() {
        
        navigationItem.title = "Cоздать вакансию"
        
        guard let categoryButton = categoryButtonLabel else {return}
        categoryButton.changeButtonDisclosure(with: "Выберите категорию:")
        
        guard let headingVacansy = descriptionVacansyHeadingLabel else  {return}
        headingVacansy.text = "Описание вакансии:"
        
        guard let addButton = addVacansyLabel else {return}
        addButton.changeStyleButton(with: "Добавить вакансию")
        
        guard let city = cityLabel, let category = categoryLabel else {return}
        city.styleLabel(with: " не выбран ")
        category.styleLabel(with: " не выбрана ")
        
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
    
    // keyboard hide and show
    @objc func updateChangeFrame (notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            
        } else {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

//MARK: Load API data
extension AddVacansyController {
    
    private func parseData() {
        
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
                    self.dropDownCities.optionArray = arrayCities
                    // The the Closure returns Selected Index and String
                    self.dropDownCities.didSelect{(selectedText , _ ,_) in
                        self.cityLabel.text = " \(selectedText) "
                    }
                }
            }
        }
    }
}
