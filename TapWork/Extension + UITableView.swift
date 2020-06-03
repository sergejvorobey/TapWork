//
//  Extension + UITableView.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func addCorner(){
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

//    func addShadow(){
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowRadius = 5
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = .zero
//        self.layer.masksToBounds = false
//    }
}
