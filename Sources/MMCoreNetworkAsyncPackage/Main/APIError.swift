//
//  APIError.swift
//  
//
//  Created by Павел Кузин on 08/02/2022.
//

import Foundation



public enum APIError: Error, LocalizedError {
    
    
    case badURL
    case badData
    case badRequest
    case badMapping
    case noHTTPResponse
    case unacceptableStatusCode(Int)
    case genericError(String) /// error with message
    
    public var errorDescription: String? {
        
        switch self {
        case .badURL, .badData, .badRequest, .badMapping, .noHTTPResponse:
            return "Не удалось совершить операцию"
        case .unacceptableStatusCode(let code):
            return "Не удалось совершить операцию. Код ошибки: \(code)"
        case .genericError(let message):
            return message
        }
        
    }
}
