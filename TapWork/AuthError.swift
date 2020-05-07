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

enum AuthError {
    case notFilled
    case invalidEmail
    case fieldsDataNotFound
    case unknownError
    case serverError
    
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
            return NSLocalizedString("Unknown Error", comment: "")
        case .serverError:
            return NSLocalizedString("Server Error", comment: "")
        }
    }
}
