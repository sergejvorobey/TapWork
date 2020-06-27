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
    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.addCorner()
        self.backView.addShadow()
    }
}


