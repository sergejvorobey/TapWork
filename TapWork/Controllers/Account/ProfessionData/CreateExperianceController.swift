//
//  CreateExperianceController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 10/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase
//import BonsaiController

class CreateExperianceController: UIViewController {
    
    @IBOutlet weak var namePlaceTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var responsibilityTextView: UITextView!
    @IBOutlet weak var durationOfWorkLabel: UILabel!
    @IBOutlet weak var counterDurationLabel: UILabel!
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var durationSliderLabel: UISlider! {
        didSet {
            durationSliderLabel.maximumValue = 24
            durationSliderLabel.minimumValue = 1
            durationSliderLabel.value = 1
        }
    }
     @IBOutlet weak var buttonView: UIView!
    
    var expDataUser: Places?
    var transitionStatus = ""
    var indexArray: Int?
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO
        buttonView.addShadow()
        navigationItem.title = "Место работы"
        saveButtonLabel.changeStyleButton(with: "Сохранить")
        namePlaceTextField.placeholder = "Название места"
        professionTextField.placeholder = "Ваша должность"
        durationOfWorkLabel.text = "Как долго работали?"
        responsibilityTextView.addCorner()
        responsibilityTextView.text = ""
//        counterDurationLabel.text = "1 месяц"
        
        namePlaceTextField.delegate = self
        professionTextField.delegate = self
        responsibilityTextView.delegate = self
        
        if let place = expDataUser {
            namePlaceTextField.text = place.namePlace
            professionTextField.text = place.profession
            responsibilityTextView.text = place.responsibility
            counterDurationLabel.text = place.duration
//            let numberFormatter = NumberFormatter()
//            let number = numberFormatter.number(from: place.duration ?? "0")
//            let numberFloatValue = number?.floatValue
//            
//            durationSliderLabel.value = numberFloatValue ?? 0
        }
        professionTextField.becomeFirstResponder()
        //touch text field
        professionTextField.addTarget(self, action: #selector(selectProfession), for: .touchDown)
    
    }
 
    
    @objc func selectProfession(textField: UITextField) {
       performSegue(withIdentifier: "SelectProfessionController", sender: nil)
    }
    
    @IBAction func durationSlider(_ sender: UISlider) {
        let duration = Int(sender.value)

        switch duration {
        case 1:
            counterDurationLabel.text = "\(duration) месяц"
        case 2...4:
            counterDurationLabel.text = "\(duration) месяца"
        case 5...11:
            counterDurationLabel.text = "\(duration) месяцев"
        case 12:
            counterDurationLabel.text = "1 год"
        case 14:
            counterDurationLabel.text = "1.5 года"
        case 16:
            counterDurationLabel.text = "2 годa"
        case 18:
            counterDurationLabel.text = "2.5 годa"
        case 20:
            counterDurationLabel.text = "3 года"
        case 22:
            counterDurationLabel.text = "4 года"
        case 24:
            counterDurationLabel.text = "5+ лет"
        default:
            break
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        let infoUser = Users(user: currentUsers)
        
        let place: [String: Any] = [
            "namePlace": namePlaceTextField.text!,
            "profession":professionTextField.text!,
            "duration": counterDurationLabel.text!,
            "responsibility": responsibilityTextView.text!]
        
        if transitionStatus == "CREATE_EXPERIENCE" {
            db.collection("users")
                .document(infoUser.userId)
                .collection("userData")
                .document("profession")
                .updateData([
                    "experience": ["places": [place]]
            ])
        } else {
            db.collection("users")
                .document(infoUser.userId)
                .collection("userData")
                .document("profession")
                .updateData([
                    "experience": ["places": [place]]
            ])
        }
//
//            {(error) in
//            print(error?.localizedDescription)
//        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SelectProfessionController" {
//            segue.destination.transitioningDelegate = self
//            segue.destination.modalPresentationStyle = .custom
//        }
//    }
    
    @IBAction func unwindToCreateExperiance(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToCreateExp" {
            let selectProfVC = segue.source as? SelectProfessionController
            self.professionTextField.text = selectProfVC?.checkProfession
        }
    }
}

//MARK: Text View Delegate
extension CreateExperianceController: UITextViewDelegate, UITextFieldDelegate {
    
    // hide the keyboard when you click on Done text View
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // hide the keyboard when you click on Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == professionTextField {
            return false
        }
        return true
    }
}

