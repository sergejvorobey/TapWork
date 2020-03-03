//
//  HelperExtensions.swift
//  TapWork
//
//  Created by Sergey Vorobey on 27/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit


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
}

