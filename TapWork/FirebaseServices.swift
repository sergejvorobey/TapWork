//
//  FirebaseServices.swift
//  TapWork
//
//  Created by Sergey Vorobey on 10/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class LoaderDataFirebase {
    
    private var infoUser: Users!
    private var ref: DatabaseReference!
    
//    var userDataArray = [CurrentUser]()
//    var vacancies = [Vacancy]()
    
   
    
    typealias userCallBack = (_ user: [CurrentUser]?, _ status: Bool, _ message: String) -> Void
    typealias vacansyCallBack = (_ vacansy: [Vacancy]?, _ status: Bool, _ message: String) -> Void
    
    var callBack: userCallBack?
    var vacansyCallBack: vacansyCallBack?
    
    func refDatebase()  {
        
        guard let currentUsers = Auth.auth().currentUser else { return }
        infoUser = Users(user: currentUsers)
        ref = Database.database().reference(withPath: "users").child(String(infoUser.userId))
        
        let db = Firestore.firestore()
        db.collection("users").document(infoUser.userId).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot, snapshot.exists else {return}
            
            guard let data = snapshot.data() else {return}
            
            if let timestamp = data["dateRegister"] as? Timestamp {
                
                let dateRegister = timestamp.dateValue()
                let userDataArray = [CurrentUser(dateRegister: dateRegister,
                                                  email: data["email"] as? String,
                                                  firstName: data["firstName"] as? String,
                                                  lastName: data["lastName"] as? String,
                                                  birth: data["birth"] as? String,
                                                  profileImageUrl: data["profileImageUrl"] as? String,
                                                  roleUser: data["roleUser"] as? String,
                                                  specialization: data["specialization"] as? String,
                                                  uid: data["uid"] as? String)]
                
                self.callBack?(userDataArray, true,"")
            }
            
//            self.callBack?(userDataArray, true,"")
            ////
            //            do {
            //                let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
            //                let user = try JSONDecoder().decode(CurrentUser.self, from: jsonData)
            //
            //                self.callBack?([user], true,"")
            ////                print(user)
            //            }
            //            catch {
            //                self.callBack?(nil, false, error.localizedDescription)
            //            }
        }
    }
    
    func getDataVacancies() {
        
        ref = Database.database().reference(withPath: "vacancies")
        
        ref.observe(.value) {(snapshot) in

            var _vacancies = Array<Vacancy>()
            for item in snapshot.children {
                let vacansy = Vacancy(snapshot: item as! DataSnapshot)
               
                _vacancies.append(vacansy)
//                _vacancies.append(vacansy)
//                self.vacancies.append(vacansy)
//                print(_vacancies)
            }
//            self.vacancies = _vacancies
            _vacancies.sort(by: {$0.timestamp > $1.timestamp})
            self.vacansyCallBack?(_vacancies, true,"")
        }
    }
    
    func completionHandler(callBack: @escaping userCallBack) {
        self.callBack = callBack
    }
    
    func completionHandlerVacansy(vacansyCallBack: @escaping vacansyCallBack) {
        self.vacansyCallBack = vacansyCallBack
    }
}
