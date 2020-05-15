//
//  ModelCurrentUser.swift
//  TapWork
//
//  Created by Sergey Vorobey on 15/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUser: Decodable {
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var profileImageUrl: String?
    var roleUser: String?
    var specialization: String?
    var uid: String?

    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case firstName = "firstName"
        case lastName = "lastName"
        case profileImageUrl = "profileImageUrl"
        case roleUser = "roleUser"
        case specialization = "specialization"
        case uid = "uid"

    }
}
//    init(email: String?,
//         firstName: String?,
//         lastName: String?,
//         profileImageUrl: String?,
//         roleUser: String?,
//         specialization: String?,
//         uid: String?) {
//
//        self.email = email
//        self.firstName = firstName
//        self.lastName = lastName
//        self.profileImageUrl = profileImageUrl
//        self.roleUser = roleUser
//        self.uid = uid
//        self.ref = nil
//    }
    
//    init(snapshot: DataSnapshot) {
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        email = snapshotValue["email"] as? String
//        firstName = snapshotValue["firstName"] as? String
//        lastName = snapshotValue["lastName"] as? String
//        profileImageUrl = snapshotValue["profileImageUrl"] as? String
//        roleUser = snapshotValue["roleUser"] as? String
//        uid = snapshotValue["uid"] as? String
//        ref = snapshot.ref
//    }
    
//    init() {
//        <#statements#>
//    }
    
//}
