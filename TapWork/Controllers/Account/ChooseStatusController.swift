//
//  ChooseStatusController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 22/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ChooseStatusController: UIViewController {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var chooseSearchJobLabel: UIButton!
    @IBOutlet weak var chooseEmployerLabel: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chooseEmployerLabel.changeStyleButton(with: "Работодатель")
        chooseSearchJobLabel.changeStyleButton(with: "Ищу работу")
        navigationItem.title = "Выберите статус"
        descriptionLbl.text = "На TapWork каждый пользователь одновременно и работодатель, и соискатель. Переключить ваш статус можно в любое время"
 
    }
    
   
    @IBAction func searchJobButton(_ sender: UIButton) {

    }
    
    @IBAction func employerButton(_ sender: UIButton) {
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let registerAccountVC = segue.destination as? RegisterAccountController else {return}
        switch segue.identifier {
        case "RegisterUser":
            registerAccountVC.roleUser = "Ищу работу"
        default:
            registerAccountVC.roleUser = "Работодатель"
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
