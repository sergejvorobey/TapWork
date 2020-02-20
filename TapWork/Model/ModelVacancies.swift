//
//  ModelVacancies.swift
//  TapWork
//
//  Created by Sergey Vorobey on 08/02/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

struct Vacancy {
    
    var heading: String
    var content: String
    var payment: String
    var publicationDate: String
    
}

struct VacansyProvider {
    
    var vacancies: [Vacancy] {
        return [vacansyOne, vacansyTwo, vacansyThree, vacansyTwo]
    }
}

let vacansyOne = Vacancy(heading: "Нужен официант",
                         content: "Новый ресторан Экспромт приглашает на постоянную работу официантов.",
                         payment: "2500",
                         publicationDate: "8.02.2020 14:37")

let vacansyTwo = Vacancy(heading: "Срочно официант",
                         content: "В ресторан-кафе Пушкинъ, который находиться в огромном и манящим фонтаном ГУМе, открыт набор ОФИЦИАНТОВ!!!!!!!!!! Мы приглашаем вас стать частью легендарной команды! Обязанности:Обслуживание гостей согласно стандартам сервиса;Создание в ресторане атмосферы гостеприимства;Помощь в выборе блюд и напитков;Консультирование гостей по меню.",
                         payment: "65000",
                         publicationDate: "9.02.2020 14:37")

let vacansyThree = Vacancy(heading: "Срочно официант",
                           content: "В ресторан-кафе Пушкинъ, который находиться в огромном и манящим фонтаном ГУМе, открыт набор ОФИЦИАНТОВ!!!!!!!!!! Мы приглашаем вас стать частью легендарной команды! Обязанности:Обслуживание гостей согласно стандартам сервиса;Создание в ресторане атмосферы гостеприимства;Помощь в выборе блюд и напитков;Консультирование гостей по меню.",
                           payment: "65000",
                           publicationDate: "9.02.2020 14:37")


