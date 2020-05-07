//
//  CitiesLoaderAPI.swift
//  TapWork
//
//  Created by Sergey Vorobey on 02/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import Alamofire

class CitiesLoaderAPI {
    
    private let domainURL = "https://api.vk.com/method/database.getCities?"
    private let country_id = 1
    private let need_all = 0
    private let count = 1000
    private let v = 5.103
    private let accessToken = "ad747ff07e1a3b8aa5fc2c34cffb203b8423c8d82bdf4418bb5a3d54902abba164da91399158816b1c495"
    private var baseURL: String {
        return "\(domainURL)" +
                "country_id=\(country_id)" +
                "&need_all=\(need_all)" +
                "&count=\(count)" +
                "&access_token=\(accessToken)" +
                "&v=\(v)"
    }

    typealias citiesCallBack = (_ cities: [Items]?, _ status: Bool, _ message: String) -> Void
   
    private var callBack: citiesCallBack?

    func getAllCitiesName() {
       
        AF.request(self.baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseData {(responseData) in
            
            guard let data = responseData.data else {return}
//            print(data)
            self.callBack?(nil, false, "")

            do {
                let cities = try JSONDecoder().decode(City.self, from: data)
//                print(cities)
                let citiesList = cities.response?.items
//                print(citiesList)
                self.callBack?(citiesList!, true,"")
                
            }
            
            catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping citiesCallBack) {
        self.callBack = callBack
    }
}
