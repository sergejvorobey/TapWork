//
//  VacanciesCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 04/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class VacanciesCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cityVacansyLabel: UILabel!
    @IBOutlet weak var categoryVacansyLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var publicationDateLabel: UILabel!
    @IBOutlet weak var userPublicationLbl: UILabel!
    @IBOutlet weak var countViewsLbl: UILabel!
//    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        let color = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
//        self.layer.borderWidth = 10
//        self.layer.cornerRadius = 20
//        self.layer.borderColor = color.cgColor
//        self.layer.masksToBounds = true
//        self.backgroundColor = UIColor.white
    }
}


