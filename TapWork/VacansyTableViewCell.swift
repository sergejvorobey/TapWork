//
//  VacansyTableViewCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class VacansyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cityVacansyLabel: UILabel!
    @IBOutlet weak var categoryVacansyLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var publicationDateLabel: UILabel!
}

extension VacansyTableViewCell {
    
    func changeCellColor() {
        
        let color = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 8
    
    }
}
