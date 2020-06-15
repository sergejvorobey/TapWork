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
        
//        let color = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
//        self.layer.borderWidth = 10
//        self.layer.cornerRadius = 20
//        self.layer.borderColor = color.cgColor
//        self.layer.masksToBounds = true
//        self.backgroundColor = UIColor.white
//           
    }
    
    @IBAction func editProfDataButton(_ sender: UIButton) {
        
    }
}
