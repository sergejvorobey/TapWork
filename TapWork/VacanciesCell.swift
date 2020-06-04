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
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
}

extension VacanciesCell {

    func changeCellColor() {

//        let color = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)

        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
//        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 8
        self.layer.borderColor = UIColor.clear.cgColor

    }
}
