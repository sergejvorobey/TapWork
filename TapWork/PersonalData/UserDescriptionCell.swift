//
//  UserDescriptionCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class UserDescriptionCell: UITableViewCell {

    @IBOutlet weak var iconCell: UIImageView!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editProfessionLabel: UIButton!
    
    @IBOutlet weak var backView: UIView!
    
   override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.addCorner()
        self.backView.addShadow()
        editProfessionLabel.setTitle("Изменить", for: .normal)
        editProfessionLabel.setTitleColor(.red, for: .normal)
    }
}
