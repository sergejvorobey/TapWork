//
//  CategoriesLoaderAPI.swift
//  TapWork
//
//  Created by Sergey Vorobey on 22/06/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Alamofire

class CategoriesLoaderAPI {
    
    fileprivate let baseURL = "http://mob.adon.asia"
    typealias categoriesCallBack = (_ categories: [CategoriesList]?, _ status: Bool, _ message: String) -> Void

    var callBack: categoriesCallBack?
    
    func getCategoriesList() {
        
        AF.request(self.baseURL, method: .get, encoding: URLEncoding.default).responseJSON { (responseJSON) in
            guard let data = responseJSON.data else {return}
            self.callBack?(nil, false, "")

            do {
                let categoriesList = try JSONDecoder().decode([CategoriesList].self, from: data)
                self.callBack?(categoriesList, true,"")
            }
            catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
        
//        AF.request(self.baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseData {(responseData) in
//
//            guard let data = responseData.data else {return}
//            self.callBack?(nil, false, "")
//
//            do {
//                let categoriesList = try JSONDecoder().decode([CategoriesList].self, from: data)
////                let categories = try JSONDecoder().decode([CategoriesList].self, from: data)
//                let citiesList = categoriesList
//                print(citiesList)
////                self.callBack?(categories, true,"")
////                print(categories)
//
//            }
//
//            catch {
//                self.callBack?(nil, false, error.localizedDescription)
//            }
//        }
    }
    func completionHandler(callBack: @escaping categoriesCallBack) {
        self.callBack = callBack
    }
}
