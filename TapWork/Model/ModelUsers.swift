//
//  ModelUsers.swift
//  TapWork
//
//  Created by Sergey Vorobey on 24/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase

struct Users {
    
    var userId: String
    var emailUser: String
    
    init(user: User) {
        self.userId = user.uid
        self.emailUser = user.email!
    }
}


