//
//  Extension + UIView.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIView {
    
    func changeColorView() {
        
        let color = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        self.backgroundColor = color
        
    }
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        let actibityIndocatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: activityColor, padding: .none)
        actibityIndocatorView.center = self.center
        
        actibityIndocatorView.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(actibityIndocatorView)
        self.addSubview(backgroundView)
        //        self.addSubview(actibityIndocatorView)
    }
    
    func activityStopAnimating() {
        
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
