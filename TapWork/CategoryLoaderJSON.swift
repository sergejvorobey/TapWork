//
//  CategoryLoaderJSON.swift
//  TapWork
//
//  Created by Sergey Vorobey on 24/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

class DataLoader {
    
    var categoryData = [CategoriesList]()
    
    typealias categoriesCallBack = (_ categories:[CategoriesList]?, _ status: Bool, _ message:String) -> Void

    var callBack: categoriesCallBack?
    
    init() {
           getAllCategoriesName()
//           sort()
       }
    
    func getAllCategoriesName() {
        
        if let path = Bundle.main.url(forResource: "Categories", withExtension: "json") {
            let data = NSData(contentsOf: path)
            
            do {
                guard let data = data else {return}
                let categories = try JSONDecoder().decode([CategoriesList].self, from: data as Data)
                //            let countries = try JSONDecoder().decode([Country].self, from: data as! Data)
                self.categoryData = categories
                self.callBack?(categories, true,"")
//                print(categoryData)
                
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    func completionHandler(callBack: @escaping categoriesCallBack) {
        self.callBack = callBack
    }
}
