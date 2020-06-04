//
//  TitleVacansyController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 03/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class TitleVacansyController: UIViewController {
    
//    @IBOutlet weak var titleVacansyLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var summaryCountLbl: UILabel!
    
    
    //    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var nextButtonLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        updateCharacterCount()
        navigationItem.title = "Название"
        
    }
    
    private func setStyleItem() {
        
        nextButtonLabel.addShadow()
//        titleVacansyLabel.text = "Название"
//        titleVacansyLabel.isHidden = true
        nextButtonLabel.changeStyleButton(with: "Далее")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setStyleItem()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        return updatedText.count <= 29
    }
}



