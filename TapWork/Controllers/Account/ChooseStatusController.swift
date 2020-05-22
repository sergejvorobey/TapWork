//
//  ChooseStatusController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 22/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ChooseStatusController: UIViewController {

    @IBOutlet weak var chooseSearchJobLabel: UIButton!
    @IBOutlet weak var chooseEmployerLabel: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        chooseEmployerLabel.changeStyleButton(with: "Работодатель")
        chooseSearchJobLabel.changeStyleButton(with: "Ищу работу")
        navigationItem.title = "Выберите статус"
        
    }
    
    @IBAction func searchJobButton(_ sender: UIButton) {

    }
    
    @IBAction func employerButton(_ sender: UIButton) {
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.identifier == "RegisterEmployer" {
                  if let registerAccountVC = segue.destination as? RegisterAccountController {
                    registerAccountVC.statusUser = "Работодатель"
                  }
              }
          }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
