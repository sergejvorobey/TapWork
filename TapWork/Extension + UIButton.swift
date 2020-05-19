//
//  Extension + UIButton.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    func changeStyleButton(with text: String) {
        
        self.setTitle(text, for: .normal)
        self.backgroundColor = .red
        self.layer.cornerRadius = 15
        self.tintColor = .white
    }
    
    func changeButtonDisclosure(with text: String) {
        
        let disclosure = UITableViewCell()
        disclosure.frame = self.bounds
        disclosure.accessoryType = .disclosureIndicator
        disclosure.isUserInteractionEnabled = false
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.2
        self.layer.masksToBounds = true
        
        self.addSubview(disclosure)
    }
}
