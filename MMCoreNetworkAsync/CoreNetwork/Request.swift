//
//  Request.swift
//  
//
//  Created by Павел Кузин on 08/02/2022.
//

import Foundation



public protocol Request {
    var path : String { get set }
    var method : HTTPMethod { get set }
    var contentType : HTTPContentType { get set }
    var query : [String: String]? { get set }
    func makeURLRequest(url: URL, serializer: Serializer?) async throws -> URLRequest
    
}

public extension Request {
    static func GET(path: String, query: [String:String]? = nil) -> Request {
        return BaseRequest(
            path: path,
            query: query,
            method: .GET,
            contentType: .json
        )
    }
    
    static func PUT(path: String, query: [String:String]? = nil) -> Request {
        return BaseRequest(
            path: path,
            query: query,
            method: .PUT,
            contentType: .json
        )
    }
    
    static func DELETE(path: String, query: [String:String]? = nil) -> Request {
        return BaseRequest(
            path: path,
            query: query,
            method: .DELETE,
            contentType: .json
        )
    }
    
}

public struct BaseRequest: Request {
    
    public func makeURLRequest(url: URL, serializer: Serializer? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    public var path : String
    public var query : [String: String]?
    public var method : HTTPMethod
    public var contentType : HTTPContentType
    
}


public struct PostRequest<T: Encodable>: Request {
    
    public func makeURLRequest(url: URL, serializer: Serializer?) async throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
            switch contentType {
            case .json:
                let encodedData = try await serializer?.encode(body)
                request.httpBody = encodedData
            case .formData:
                break
            case .urlEncoded:
                let encoder = URLEncodedFormEncoder()
                let data: Data? = try? encoder.encode(body)
                request.httpBody = data
                
            case .other:
                break
            }
        }
        return request
    }
    
    public var path : String
    public var body: T?
    public var query : [String: String]?
    public var method : HTTPMethod = .POST
    public var contentType : HTTPContentType
    
}



