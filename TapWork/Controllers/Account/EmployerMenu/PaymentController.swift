//
//  PaymentController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

class PaymentController: UIViewController {
    
    @IBOutlet weak var headerSectionLabel: UILabel!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var summaryCountLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var messagePhoneLabel: UILabel!
    @IBOutlet weak var switchShowPhone: UISwitch!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintSwitch: NSLayoutConstraint!
    
    var headerVacansy: String?
    var cityVacansy: String?
    var contentVacansy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupItems()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    //MARK: create new vacansy
        addVacansy(heading: headerVacansy,
                   city: cityVacansy,
                   content: contentVacansy,
                   payment: paymentTextField.text,
                   phone: phoneTextField.text)
        {(result) in
            switch result {
            case .success:
                self.successAlert(title: "Успешно!", message: "Вакансия опубликована!")
            case .failure(let error):
                self.errorAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
       //MARK: hide controller
        self.disMissController()
    }
    
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        checkShowPhone()
    }
    
    private func setupItems() {
        delegates()
        changeFrameKeyboard()
        addDoneButtonOnNumberKeyboard()
        headerSectionLabel.text = "Бюджет и телефон"
        nextButtonLabel.changeStyleButton(with: "Опубликовать")
        errorLabel.isHidden = true
        messagePhoneLabel.text = "Указывать телефон"
        phoneTextField.placeholder = "+7 (XXX) XXXX-XXX"
        paymentTextField.placeholder = "₽"
        paymentTextField.becomeFirstResponder()
    }
    
    private func delegates() {
        paymentTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    private func checkShowPhone() {
        
        if switchShowPhone.isOn {
            
            messagePhoneLabel.text = "Указывать телефон"
            
            self.bottomConstraintSwitch.constant = 80
            
            UIView.animate(withDuration: 0.5) {
                self.phoneTextField.isHidden = false
                self.view.layoutIfNeeded()
            }
        } else {
            messagePhoneLabel.text = "Не указывать телефон"
            
            self.bottomConstraintSwitch.constant = 10
            self.phoneTextField.text = ""
            
            UIView.animate(withDuration: 0.5) {
                self.phoneTextField.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: Phone formatter
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

extension PaymentController: UITextFieldDelegate {
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: create phone with formatter
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            return false
        }
        return true
    }
}

//MARK: Setup keyboard methods
extension PaymentController {
    
    //MARK: When the keyboard appears, indent from the keyboard to the buttons
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
        
        self.phoneTextField.inputAccessoryView = doneToolbar
        self.paymentTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.phoneTextField.resignFirstResponder()
        self.paymentTextField.resignFirstResponder()
    }
}

//MARK: Adding New Vacansy in Firebase
extension PaymentController {
    
    // MARK: Add vacansy in database
    private func addVacansy(heading: String?,
                            city: String?,
                            content: String?,
                            payment: String?,
                            phone: String?,
                            completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isConnectedToNetwork()  else {
            completion(.failure(AuthError.serverError))
            return
        }
        //MARK: check field filled
        guard Validators.isFilledTextField(text: payment) else {
            completion(.failure(AuthError.notFilled))
            return
        }

        guard let heading = heading,
            let city = city,
            let content = content,
            let payment = payment,
            let phone = phone
            else {
                completion(.failure(AuthError.unknownError))
                return
        }
        
        //MARK: check field lenght
        guard Validators.checkLengthField(text: payment, minCount: 3, maxCount: 5) else {
            completion(.failure(AuthError.lenghtPayment))
            return
        }

        guard let currentUsers = Auth.auth().currentUser else { return }
        let infoUser = Users(user: currentUsers)
        let ref = Database.database().reference(withPath: "vacancies")
        let vacansy = Vacancy(userId: infoUser.userId,
                              city: city,
                              heading: heading,
                              content: content,
                              phoneNumber: phone,
                              payment: payment)
        let vacansyRef = ref.child(vacansy.heading)//vacansy.heading
        vacansyRef.setValue(vacansy.providerToDictionary())
        
        completion(.success)
    }
}
