//
//  Extension + UIImageView.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func changeStyleImage() {
        let defColor = UIColor.white
        self.layer.borderWidth = 0.7
        self.layer.borderColor = defColor.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
//        self.addShadow()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = self.frame.height / 2
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        
    }
}
