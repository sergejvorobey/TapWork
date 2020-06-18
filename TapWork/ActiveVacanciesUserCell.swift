//
//  ActiveVacanciesUserCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 18/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class ActiveVacanciesUserCell: UITableViewCell {
    
    @IBOutlet weak var headingVacancyLbl: UILabel!
    @IBOutlet weak var cityVacancyLbl: UILabel!
    @IBOutlet weak var categoryVacancyLbl: UILabel!
    @IBOutlet weak var contentVacancyLbl: UILabel!
    @IBOutlet weak var paymenVacancyLbl: UILabel!
    @IBOutlet weak var publicationDateLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}
