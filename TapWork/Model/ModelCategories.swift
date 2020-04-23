//
//  ModelCategories.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

//struct Category {
//
//    var nameCategories: NameCategories
//
//}
//
//struct Specialization {
//
//    var nameSpecialization: NameSpecialization
//
//}
//
//enum NameCategories: String {
//
//    case restaurants = "Рестораны"
//    case musicians = "Музыканты"
//    case other = "Другие"
//
//}
//
//enum NameSpecialization: String {
//
//    case cook = "Повар"
//    case waiter = "Официант"
//    case barmen = "Бармен"
//    case singer = "Певец"
//    case dj = "Dj"
//    case musicianEquipment = "Музыкальное Оборудование"
//
//}
//
//struct CategoriesProvider {
//
//    var categories: [Category] {
//        return [categoryRestaurants, categoryMusicians, categoryOthers]
//    }
//}
//
//struct SpecializationsProvider {
//
//    var specializations: [Specialization] {
//        return [specializationCook, specializationWaiter, specializationBarmen]
//    }
//}
//
//let categoryRestaurants  = Category(nameCategories: .restaurants)
//let categoryMusicians    = Category(nameCategories: .musicians)
//let categoryOthers       = Category(nameCategories: .other)
//
//let specializationCook   = Specialization(nameSpecialization: .cook)
//let specializationWaiter = Specialization(nameSpecialization: .waiter)
//let specializationBarmen = Specialization(nameSpecialization: .barmen)
//let specializationSinger = Specialization(nameSpecialization: .singer)
//let specializationDj     = Specialization(nameSpecialization: .dj)
//let specializationMusicianEquipment = Specialization(nameSpecialization: .musicianEquipment)
//
//

struct Category {
    
    var name: NameCategory?
    
    enum NameCategory: String {
    
        case catering = "Общепит"
        case musicians = "Музыканты"
        
    }
}

struct Specialization {
    
    var name: String
    
}

struct CategoriesProvider {

    var categories: [Category] {
        return [categoryCatering, categoryMusicians]
    }
}

let categoryCatering  = Category(name: .catering)
let categoryMusicians = Category(name: .musicians)
