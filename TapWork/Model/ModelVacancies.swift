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
    var heading: String
    var city: String
    var category: String
    var content: String
    var phoneNumber: String
    var payment: String
    var countViews: Int
    var timestamp: Double
//    var favoritesVacancies: [String]?
    let ref: DatabaseReference?
    let key: String?
    
    init(userId: String, city: String, category: String, heading: String, content: String, phoneNumber: String, payment: String) {

        self.userId = userId
        self.heading = heading
        self.city = city
        self.category = category
        self.content = content
        self.phoneNumber = phoneNumber
        self.payment = payment
        self.countViews = 0
        self.timestamp = 00
//        self.favoritesVacancies = [""]
        self.ref = nil
        self.key = nil
    }
    
    init(snapshot: DataSnapshot) {

        let snapshotValue = snapshot.value as! [String: AnyObject]
        userId = snapshotValue["userId"] as! String
        heading = snapshotValue["heading"] as! String
        city = snapshotValue["city"] as! String
        category = snapshotValue["category"] as! String
        content = snapshotValue["content"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        payment = snapshotValue["payment"] as! String
        countViews = snapshotValue["countViews"] as! Int
        timestamp = snapshotValue["timestamp"] as! Double
//        favoritesVacancies = snapshotValue["favoritesVacancies"] as? [String]
        ref = snapshot.ref
        key = snapshot.key

    }

    func providerToDictionary() -> Any {
        return ["userId": userId,
                "heading": heading,
                "city": city,
                "category": category,
                "content": content,
                "payment": payment,
                "countViews": countViews,
                "phoneNumber": phoneNumber,
//                "favoritesVacancies": favoritesVacancies,
                "timestamp": [".sv": "timestamp"]]
    }
}

