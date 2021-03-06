//
//  ActiveVacanciesUserCell.swift
//  TapWork
//
//  Created by Sergey Vorobey on 18/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class EmployerVacancyCell: UITableViewCell {
    
    @IBOutlet weak var employerPublicationHeadingLbl: UILabel!
    @IBOutlet weak var headingVacancyLbl: UILabel!
    @IBOutlet weak var cityVacancyLbl: UILabel!
    @IBOutlet weak var categoryVacancyLbl: UILabel!
    @IBOutlet weak var contentVacancyLbl: UILabel!
    @IBOutlet weak var paymenVacancyLbl: UILabel!
    @IBOutlet weak var publicationDateLbl: UILabel!
    @IBOutlet weak var countViewsLbl: UILabel!
    @IBOutlet weak var countResponseLbl: UILabel!
    @IBOutlet weak var menuCurrentVacancyBtn: UIButton!
    
    
    @IBOutlet weak var employerCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        employerCellView.addShadow()
        employerCellView.addCorner()
        
//        menuCurrentVacancyBtn.addTarget(self, action: #selector(menuBtn(sender:)), for: .touchUpInside)
       
    }
    
//    @objc func menuBtn(sender: UIButton){
//        let buttonTag = sender.tag
//        print(buttonTag)
//
//
//    }
}


