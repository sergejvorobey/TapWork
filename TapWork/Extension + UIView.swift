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
        
//        let color = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        let color = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
//        let color = UIColor.white
//        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.lightGray.cgColor, color.cgColor]
//        gradient.frame = self.bounds
//        self.layer.insertSublayer(gradient, at: 0)
        self.backgroundColor = color
    }
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        let actibityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30), type: .circleStrokeSpin, color: activityColor, padding: .none)
        actibityIndicatorView.center = self.center
        
        actibityIndicatorView.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(actibityIndicatorView)
        self.addSubview(backgroundView)
        //        self.addSubview(actibityIndocatorView)
    }
    
    func activityStopAnimating() {
        
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    func changeHeaderCell(title: String) -> UIView {
        
        let tableView = UITableView()
        
        let frame: CGRect = tableView.frame

        var label = UILabel()
        label = UILabel(frame: CGRect(x: 10, y: 10, width: 400, height: 20))
        label.text = title
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
    
    func addCorner() {
//        self.layer.borderWidth = 0.1
        self.layer.cornerRadius = 10
    }
    
    func cellCurrentUser(color: UIColor) {
//        let colorYellow = UIColor(red: 255, green: 255, blue: 204/255, alpha: 1) //yellow
//        let colorGray = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1) //gray
        self.layer.borderWidth = 10
        self.layer.cornerRadius = 20
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
    }
    
//    func cellNotCurrentUser() {
//
//    }
}

