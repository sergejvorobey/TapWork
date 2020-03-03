//
//  ShowInfoVacansyViewController.swift
//  TapWork
//
//  Created by Sergey Vorobey on 09/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ShowInfoVacansyViewController: UIViewController {
    
    var vacansyInfo: Vacancy?
    
    @IBOutlet weak var showHeadingLabel: UILabel!
    @IBOutlet weak var showContentLabel: UILabel!
    @IBOutlet weak var showPaymentLable: UILabel!
    @IBOutlet weak var responseButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let vacansy = vacansyInfo {
            
            showHeadingLabel.text = vacansy.heading
            showContentLabel.text = vacansy.content
            showPaymentLable.text = vacansy.payment + " ₽ "
            
        }
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Вакансии",
                                                        style: .plain,
                                                        target: nil, action: nil)
        }
        
        if let button = responseButtonLabel {
               button.layer.cornerRadius = 10
               button.layer.backgroundColor = UIColor.red.cgColor
               button.setTitle("Откликнуться", for: .normal)
               button.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func responseButton(_ sender: UIButton) {

        // MARK: response vacansy 
    }
}
