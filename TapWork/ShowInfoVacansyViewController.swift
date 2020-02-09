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
    @IBOutlet weak var showPublicationDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let vacansy = vacansyInfo {
            showHeadingLabel.text = vacansy.heading
            showContentLabel.text = vacansy.content
           // showContentLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
           // showContentLabel.numberOfLines = 0
            showPaymentLable.text = vacansy.payment + " ₽ "
            showPublicationDateLabel.text = vacansy.publicationDate
        }
    }
    
}
