//
//  ModelVacancies.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase

struct Vacancy {
    
    var userId: String
   // var userName: String
    var heading: String
    var content: String
    var phoneNumber: String
    var payment: String
    var timestamp: Double
    let ref: DatabaseReference?
    
    init(userId: String, heading: String, content: String, phoneNumber: String, payment: String) {
        
        self.userId = userId
     //   self.userName = userName
        self.heading = heading
        self.content = content
        self.phoneNumber = phoneNumber
        self.payment = payment
        self.timestamp = 00
        self.ref = nil
    }
    
    
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        userId = snapshotValue["userId"] as! String
       // userName = snapshotValue["userName"] as! String
        heading = snapshotValue["heading"] as! String
        content = snapshotValue["content"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        payment = snapshotValue["payment"] as! String
        timestamp = snapshotValue["timestamp"] as! Double
        ref = snapshot.ref
        
        }
    
        func providerToDictionary() -> Any {
            return ["userId": userId,
                   // "userName": userName,
                    "heading": heading,
                    "content": content,
                    "payment": payment,
                    "phoneNumber": phoneNumber,
                    "timestamp": [".sv": "timestamp"]
            ]
    }
}

//struct VacansyProvider {
//
//    var vacancies: [Vacancy] {
//        return [vacansyOne, vacansyTwo, vacansyThree, vacansyTwo]
//    }
//}
//
//let vacansyOne = Vacancy(userId: "12345" ,
//                         heading: "Нужен официант",
//                         content: "Новый ресторан Экспромт приглашает на постоянную работу официантов.",
//                         payment: "2500"/*,
//                         timestamp: "8.02.2020 14:37"*/)
//
//let vacansyTwo = Vacancy(userId: "12345",
//                         heading: "Срочно официант",
//                         content: "В ресторан-кафе Пушкинъ, который находиться в огромном и манящим фонтаном ГУМе, открыт набор ОФИЦИАНТОВ!!!!!!!!!! Мы приглашаем вас стать частью легендарной команды! Обязанности:Обслуживание гостей согласно стандартам сервиса;Создание в ресторане атмосферы гостеприимства;Помощь в выборе блюд и напитков;Консультирование гостей по меню.",
//                         payment: "65000"/*,
//                         timestamp: "8.02.2020 14:37"*/)
//
//let vacansyThree = Vacancy(userId: "12345",
//                           heading: "Срочно официант",
//                           content: "В ресторан-кафе Пушкинъ, который находиться в огромном и манящим фонтаном ГУМе, открыт набор ОФИЦИАНТОВ!!!!!!!!!! Мы приглашаем вас стать частью легендарной команды! Обязанности:Обслуживание гостей согласно стандартам сервиса;Создание в ресторане атмосферы гостеприимства;Помощь в выборе блюд и напитков;Консультирование гостей по меню.",
//                           payment: "65000"/*,
//                           timestamp: "8.02.2020 14:37"*/)


