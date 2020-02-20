//
//  ModelCategories.swift
//  TapWork
//
//  Created by Sergey Vorobey on 17/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

enum NameCategories: String {
    
    case restaurants = "Рестораны"
    case musicians = "Музыканты"
    case other = "Другие"
    
}

enum NameSpecialization: String {
    
     case cook = "Повар"
     case waiter = "Официант"
     case barmen = "Бармен"
     case singer = "Певец"
     case dj = "Dj"
     case musicianEquipment = "Музыкальное Оборудование"
    
}

struct Category {
    
    var nameCategories: NameCategories
   
}

struct Specialization {
    
    var nameSpecialization: NameSpecialization
    
}

struct CategoriesProvider {

    var categories: [Category] {
        return [categoryRestaurants, categoryMusicians, categoryOthers]
    }
    
    var specializations: [Specialization] {
        return [specializationCook, specializationWaiter, specializationBarmen]
    }
}

let categoryRestaurants  = Category(nameCategories: .restaurants)
let categoryMusicians    = Category(nameCategories: .musicians)
let categoryOthers       = Category(nameCategories: .other)

let specializationCook   = Specialization(nameSpecialization: .cook)
let specializationWaiter = Specialization(nameSpecialization: .waiter)
let specializationBarmen = Specialization(nameSpecialization: .barmen)
let specializationSinger = Specialization(nameSpecialization: .singer)
let specializationDj     = Specialization(nameSpecialization: .dj)
let specializationMusicianEquipment = Specialization(nameSpecialization: .musicianEquipment)

//=================================================================//

class CategoryTest {
    
    var nameCategory: NameCategories
    
    init(nameCategory: NameCategories) {
        self.nameCategory = nameCategory
    }
}

class SpecializationTest: CategoryTest {
    
    var nameSpecialization: NameSpecialization
    
    init(nameCategory: NameCategories, nameSpecialization: NameSpecialization) {
        self.nameSpecialization = nameSpecialization
        super.init(nameCategory: nameCategory)
    }
}

let barmens = SpecializationTest(nameCategory: .restaurants, nameSpecialization: .barmen)
let waiters = SpecializationTest(nameCategory: .restaurants, nameSpecialization: .waiter)
let cooks   = SpecializationTest(nameCategory: .restaurants, nameSpecialization: .cook)
let singers = SpecializationTest(nameCategory: .musicians, nameSpecialization: .singer)
let dj      = SpecializationTest(nameCategory: .musicians, nameSpecialization: .dj)
let musiciansEquipments = SpecializationTest(nameCategory: .musicians, nameSpecialization: .musicianEquipment)

