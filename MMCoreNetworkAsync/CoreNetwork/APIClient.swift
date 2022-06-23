//
//  APIClient.swift
//  
//
//  Created by Павел Кузин on 08/02/2022.
//

import Foundation

public actor APIClient {
    internal let host : String
    internal let session : URLSession
    internal let interceptor : APIClientInterceptor
    internal let httpProtocol : HTTPProtocol
    internal let serializer: Serializer
    
    public init(
        host: String,
        interceptor: APIClientInterceptor? = nil,
        httpProtocol: HTTPProtocol = .HTTPS,
        configuration: URLSessionConfiguration = .default,
        serializer: Serializer? = nil
    ) {
        self.host = host
        self.session = URLSession(configuration: configuration)
        self.interceptor = interceptor ?? DefaultAPIClientInterceptor()
        self.httpProtocol = httpProtocol
        self.serializer = serializer
    }
    
    public func send(_ request: Request, debug: Bool = false) async throws -> Response  {
        let url = try makeURL(path: request.path, query: request.query)
        var urlRequest = try await request.makeURLRequest(url: url, serializer: self.serializer)
#if DEBUG
        if debug {
            print("🚧🚧🚧 MAKING URL REQUEST:\n\(urlRequest.url?.absoluteString ?? "empty URL")\n")
        }
#endif
        interceptor.client(self, willSendRequest: &urlRequest)
        print("CORENETWORK: started network call")
        
        let (data,response) = try await session.data(from: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badData
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            // handling HTTP error
            print("CORENETWORK: Did receive error \(httpResponse.statusCode)")
            let retryPolicy = await self.interceptor.client(self, initialRequest: request, didReceiveInvalidResponse: httpResponse, data: data)
            switch retryPolicy {
            case .shouldRetry:
                print("CORENETWORK: Retrying request \(request.path)")
                let resendedResponse = try await self.send(request)
                return resendedResponse
            case .doNotRetry:
                print("CORENETWORK: Request marked as do not retry")
                throw APIError.unacceptableStatusCode(httpResponse.statusCode)
            case .doNotRetryWith(let retryError):
                throw retryError
            }
        } else {
            return Response(data: data, success: true, statusCode: httpResponse.statusCode)
        }
        
        
    }
}

extension APIClient {
    
    private func makeURL(path: String, query: [String: String]?) throws -> URL {
        guard
            let url = URL(string: path),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw URLError(.badURL)
        }
        if path.starts(with: "/") {
            components.scheme = self.httpProtocol.rawValue
            components.host = host
        }
        if let query = query {
            components.queryItems = query.map(URLQueryItem.init)
        }
        guard
            let url = components.url
        else {
            throw URLError(.badURL)
        }
        return url
    }
    
}
