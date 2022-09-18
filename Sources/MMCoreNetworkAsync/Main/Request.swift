//
//  Request.swift
//  
//
//  Created by Павел Кузин on 08/02/2022.
//

import Foundation

public struct AnyEncodable: Encodable {
    private let value: Encodable

    init(_ value: Encodable) {
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

//public protocol Request {
//    var path : String { get set }
//    var method : HTTPMethod { get set }
//    var contentType : HTTPContentType { get set }
//    var query : [String: String]? { get set }
//    func makeURLRequest(url: URL, serializer: Serializer?) async throws -> URLRequest
//
//}

public struct Request {
    public let path : String
    public let method : HTTPMethod
    public let contentType : HTTPContentType
    public let query : [String: String]?
    public let body: AnyEncodable?
    
    public init(path: String, method: HTTPMethod, contentType: HTTPContentType, query: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.contentType = contentType
        self.query = query
        self.body = nil
    }
    
    public init<T: Encodable>(path: String, method: HTTPMethod, contentType: HTTPContentType, query: [String: String]? = nil, body: T?) {
        self.path = path
        self.method = method
        self.contentType = contentType
        self.query = query
        self.body = AnyEncodable(body)
    }
    
}

public extension Request {
    
    static func POST<T: Encodable>(path: String, body: T?, contentType: HTTPContentType) -> Request {
        return Request(path: path, method: .POST, contentType: contentType, body: body)
    }
    
    static func POST(path: String, contentType: HTTPContentType) -> Request {
        return Request(path: path, method: .POST, contentType: contentType)
    }
    
    static func GET(path: String, query: [String:String]? = nil) -> Request {
        return Request(path: path, method: .GET, contentType: .json, query: query)
    }
    
    static func PUT(path: String, query: [String:String]? = nil) -> Request {
        return Request(path: path, method: .PUT, contentType: .json, query: query)
    }
    
    static func DELETE(path: String, query: [String:String]? = nil) -> Request {
        return Request(path: path, method: .DELETE, contentType: .json, query: query)
    }
    
}





