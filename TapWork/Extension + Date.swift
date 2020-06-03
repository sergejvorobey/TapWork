//
//  Extension + Date.swift
//  TapWork
//
//  Created by Sergey Vorobey on 19/05/2020.
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
//        let weeks = days / 7
        
//        switch (components) {
//
//        case _ where (years % 10 == 1 && years % 100 != 11):
//            return String.init(format: "%u год на TapWork", years)
//        case _ where ((years % 10 >= 2 && years % 10 <= 4) && !(years % 100 >= 12 && years % 100 <= 14)):
//            return String.init(format: "%u года на TapWork", years)
//        case _ where (years % 10 == 0 || (years % 10 >= 5 && years % 10 <= 9) || (years % 100 >= 11 && years % 100 <= 14)):
//            return String.init(format: "%u лет на TapWork", years)
//
//
//        case _ where (months % 10 == 1 && months % 100 != 11):
//            return String.init(format: "%u месяц на TapWork", months)
//        case _ where ((months % 10 >= 2 && months % 10 <= 4) && !(months % 100 >= 12 && months % 100 <= 14)):
//            return String.init(format: "%u месяца на TapWork", months)
//        case _ where (months % 10 == 0 || (months % 10 >= 5 && months % 10 <= 9) || (months % 100 >= 11 && months % 100 <= 14)):
//             return String.init(format: "%u месяцев на TapWork", months)
//
//
//        case _ where (weeks % 10 == 1 && weeks % 100 != 11):
//            return String.init(format: "%u неделя на TapWork", weeks)
//        case _ where ((weeks % 10 >= 2 && weeks % 10 <= 4) && !(weeks % 100 >= 12 && weeks % 100 <= 14)):
//            return String.init(format: "%u недели на TapWork", weeks)
//        case _ where (weeks % 10 == 0 || (weeks % 10 >= 5 && weeks % 10 <= 9) || (weeks % 100 >= 11 && weeks % 100 <= 14)):
//            return String.init(format: "%u недель на TapWork", weeks)
//
//
//        case _ where (days % 10 == 1 && days % 100 != 11):
//            return String.init(format: "%u день на TapWork", days)
//        case _ where ((days % 10 >= 2 && days % 10 <= 4) && !(days % 100 >= 12 && days % 100 <= 14)):
//             return String.init(format: "%u дня на TapWork", days)
//        case _ where (days % 10 == 0 || (days % 10 >= 5 && days % 10 <= 9) || (days % 100 >= 11 && days % 100 <= 14)):
//            return String.init(format: "%u дней на TapWork", days)
//
//
//        case _ where (hours % 10 == 1 && hours % 100 != 11):
//            return String.init(format: "%u час на TapWork", hours)
//        case _ where ((hours % 10 >= 2 && hours % 10 <= 4) && !(hours % 100 >= 12 && hours % 100 <= 14)):
//            return String.init(format: "%u часа на TapWork", hours)
//        case _ where (hours % 10 == 0 || (hours % 10 >= 5 && hours % 10 <= 9) || (hours % 100 >= 11 && hours % 100 <= 14)):
//            return String.init(format: "%u часов на TapWork", hours)
//
//
//        case _ where (minutes % 10 == 1 && minutes % 100 != 11):
//            return String.init(format: "%u минута на TapWork", minutes)
//        case _ where ((minutes % 10 >= 2 && minutes % 10 <= 4) && !(minutes % 100 >= 12 && minutes % 100 <= 14)):
//            return String.init(format: "%u минуты на TapWork", minutes)
//        case _ where (minutes % 10 == 0 || (minutes % 10 >= 5 && minutes % 10 <= 9) || (minutes % 100 >= 11 && minutes % 100 <= 14)):
//            return String.init(format: "%u минут на TapWork", minutes)
//
//
//        case _ where (seconds % 10 == 1 && seconds % 100 != 11):
//            return String.init(format: "%u секунда на TapWork", seconds)
//        case _ where ((seconds % 10 >= 2 && seconds % 10 <= 4) && !(seconds % 100 >= 12 && seconds % 100 <= 14)):
//            return String.init(format: "%u секунды на TapWork", seconds )
//        case _ where (seconds % 10 == 0 || (seconds % 10 >= 5 && seconds % 10 <= 9) || (seconds % 100 >= 11 && seconds % 100 <= 14)):
//            return String.init(format: "%u секунд на TapWork", seconds )
//        default:
//            return ""
//        }

        if years > 0 {
            return years == 1 ? "1 год": "\(years) лет"
        } else if months > 0 {
            return months == 1 ? "1 месяц": "\(months) месяцев"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 неделя": "\(weeks) недель"
        } else if days > 0 {
            return days == 1 ? "1 день": "\(days) дней"
        } else if hours > 0 {
            return hours == 1 ? "1 час": "\(hours) часов"
        } else if minutes > 0 {
            return minutes == 1 ? "1 минута": "\(minutes) минут"
        } else {
            return seconds == 1 ? "1 секунда": "\(seconds) секунд"
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
    
    func dateRegister() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let convertToStr = dateFormatter.string(from: self)
        
        return convertToStr
    }
}
