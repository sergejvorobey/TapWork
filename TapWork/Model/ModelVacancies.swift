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
    var content: String
    var phoneNumber: String
    var payment: String
    var timestamp: Double
    let ref: DatabaseReference?
    
    init(userId: String, city: String, heading: String, content: String, phoneNumber: String, payment: String) {

        self.userId = userId
        self.heading = heading
        self.city = city
        self.content = content
        self.phoneNumber = phoneNumber
        self.payment = payment
        self.timestamp = 00
        self.ref = nil
    }

    init(snapshot: DataSnapshot) {

        let snapshotValue = snapshot.value as! [String: AnyObject]
        userId = snapshotValue["userId"] as! String
        heading = snapshotValue["heading"] as! String
        city = snapshotValue["city"] as! String
        content = snapshotValue["content"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        payment = snapshotValue["payment"] as! String
        timestamp = snapshotValue["timestamp"] as! Double
        ref = snapshot.ref

    }

    func providerToDictionary() -> Any {
        return ["userId": userId,
                "heading": heading,
                "city": city,
                "content": content,
                "payment": payment,
                "phoneNumber": phoneNumber,
                "timestamp": [".sv": "timestamp"]]
    }
}
