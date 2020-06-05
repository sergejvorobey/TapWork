//
//  ContentVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ContentVacansyController: UIViewController {
    
    @IBOutlet weak var headerSectionLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var summaryCountLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var header: String?
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupItems()
    }
    
    private func keyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // keyboard hide and show
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
    
    func show() {
//        print(header,city)
    }
    
    private func setupItems() {
        keyboardObserver()
        nextButtonLabel.addShadow()
        updateCharacterCount()
        nextButtonLabel.changeStyleButton(with: "Далее")
        headerSectionLabel.text = "Описание"
        errorLabel.isHidden = true
        contentTextView.delegate = self
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.cornerRadius = 10
        contentTextView.setPlaceholder(with: "Описание вакансии")
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "paymentController", sender: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateCharacterCount() {
       self.summaryCountLabel.text = "\((0))/200 (мин. 20)"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        contentTextView.checkPlaceholder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContentVacansyController: UITextViewDelegate {
    // hide the keyboard when you click on Done text View
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        self.summaryCountLabel.text = "\((0) + updatedText.count)/200 (мин. 20)"
        
        //MARK: TODO
        if updatedText.count < 20 {
            errorLabel.isHidden = false
            errorLabel.textColor = .red
            errorLabel.text = "Описание слишком короткое"
        } else {
            errorLabel.isHidden = true
        }
        return updatedText.count <= 199
    }
}
