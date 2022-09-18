//
//  Response.swift
//  
//
//  Created by Павел Кузин on 08/02/2022.
//

import Foundation

public struct Response<T> {
    public let value: T
    // Original data
    public let data : Data
    public let success : Bool
    public let statusCode : Int
}
