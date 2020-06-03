//
//  ProfileCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 31/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconCell: UIImageView!
    @IBOutlet weak var editProfessionLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editProfessionLabel.setTitle("Изменить", for: .normal)
        editProfessionLabel.tintColor = .red
    }
    
    @IBAction func editProfDataButton(_ sender: UIButton) {
        
    }
}
