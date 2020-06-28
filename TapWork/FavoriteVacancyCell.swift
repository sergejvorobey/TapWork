//
//  FavoriteVacancyCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 28/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class FavoriteVacancyCell: UITableViewCell {
    
    @IBOutlet weak var headingVacancyLbl: UILabel!
    @IBOutlet weak var cityVacancyLbl: UILabel!
    @IBOutlet weak var categoryVacancyLbl: UILabel!
    @IBOutlet weak var contentVacancyLbl: UILabel!
    @IBOutlet weak var paymenVacancyLbl: UILabel!
    @IBOutlet weak var publicationDateLbl: UILabel!
    @IBOutlet weak var countViewsLbl: UILabel!
    @IBOutlet weak var menuCurrentVacancyBtn: UIButton!
    
    @IBOutlet weak var favoriteCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteCellView.addShadow()
        favoriteCellView.addCorner()
        
    }
}
