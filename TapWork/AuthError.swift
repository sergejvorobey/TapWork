//
//  AuthError.swift
//  TapWork
//
//  Created by Sergey Vorobey on 07/05/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

enum AuthResult {
    case success
    case failure(Error)
}

enum Elements: String {
    case email
    case password
    case headerVacansy = "Название"
    case cityVacansy = "Город"
    case contentVacansy = "Описание"
    case paymentVacansy = "Бюджет"
    case phoneVacansy
}

enum AuthError {
    case notFilled
    case invalidEmail
    case fieldsDataNotFound
    case lengthFiedls
    case unknownError
    case serverError

    case lenghtTitle
    case lenghtCity
    case lenghtContent
    case lenghtPayment
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Пожалуйста, заполните все поля!", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Не верно заполнено поле Email!", comment: "")
        case .fieldsDataNotFound:
            return NSLocalizedString("Логин или Пароль введены не верно!", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Проверьте интернет соединение!", comment: "")
        case .lengthFiedls:
            return NSLocalizedString("Проверьте максимальную и минимальную длину полей!", comment: "")
        case .lenghtTitle:
            return NSLocalizedString("Проверьте длину поля: \(Elements.headerVacansy.rawValue)", comment: "")
        case .lenghtCity:
            return NSLocalizedString("Проверьте длину поля: \(Elements.cityVacansy.rawValue)", comment: "")
        case .lenghtContent:
            return NSLocalizedString("Проверьте длину поля: \(Elements.contentVacansy.rawValue)", comment: "")
        case .lenghtPayment:
            return NSLocalizedString("Проверьте длину поля: \(Elements.paymentVacansy.rawValue)", comment: "")
        }
    }
}
