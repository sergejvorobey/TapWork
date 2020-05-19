//
//  Extension + UILabel.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit

//MARK: change style label
extension UILabel {
    func styleLabel(with text: String)  {
        self.text = text
        let swiftColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.backgroundColor = swiftColor
        self.layer.cornerRadius = 8
        //        self.layer.borderWidth = 0.1
        self.layer.masksToBounds = true
    }
}
