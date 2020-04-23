//
//  ShowInfoVacansyCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 21/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ShowInfoVacansyCell: UITableViewCell {

    @IBOutlet weak var headingVacansyLabel: UILabel!
    @IBOutlet weak var categotyVacansyLabel: UILabel!
    @IBOutlet weak var cityVacansyLabel: UILabel!
    @IBOutlet weak var contentVacansyLabel: UILabel!
    @IBOutlet weak var paymentVacansyLabel: UILabel!
    @IBOutlet weak var responseButtonLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityVacansyLabel.text = "Москва" //TODO: peredelati

        if let button = self.responseButtonLabel {
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor.red.cgColor
            button.setTitle("Откликнуться", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func responseButton(_ sender: UIButton) {
    }
    
   private func styleCategoryLabel() {
        if let category = categotyVacansyLabel {
            let swiftColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
            category.backgroundColor = swiftColor
            category.layer.cornerRadius = 10
            category.layer.masksToBounds = true
        }
    }
}

