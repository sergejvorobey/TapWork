//
//  ExperienceUserCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 14/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ExperienceUserCell: UITableViewCell {

    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var responsibilityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
