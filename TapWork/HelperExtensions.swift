//
//  HelperExtensions.swift
//  TapWork
//
//  Created by Sergey Vorobey on 27/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


extension Date {
    
    func calenderTimeSinceNow() -> String {
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 год назад": "\(years) лет назад"
        } else if months > 0 {
            return months == 1 ? "1 месяц назад": "\(months) месяцев назад"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 неделя назад": "\(weeks) недель назад"
        } else if days > 0 {
            return days == 1 ? "1 день назад": "\(days) дней назад"
        } else if hours > 0 {
            return hours == 1 ? "1 час назад": "\(hours) часов назад"
        } else if minutes > 0 {
            return minutes == 1 ? "1 минута назад": "\(minutes) минут назад"
        } else {
            return seconds == 1 ? "1 секунда назад": "\(seconds) секунд назад"
        }
    }
    
    func publicationDate(withDate date: Date) -> String {
        
        var currentDatePublic = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        currentDatePublic = formatter.string(from: date)
        return currentDatePublic
    }
}

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

extension UITextView{
    
    func setPlaceholder(with text: String) {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}

extension UIView {
    
    func changeColorView() {
        
        let color = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        self.backgroundColor = color
        
    }
}

extension UIImageView {

    func changeStyleImage() {
        self.layer.borderWidth = 0.3
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

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

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    
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
