//
//  RequestError.swift
//
//
//  Created by Kemal Türk on 28.07.2022.
//

import Foundation


public struct RequestError: Error {
    public let statusCode: Int
    public let body: String
    public init(statusCode: Int, body: String) {
        self.statusCode = statusCode
        self.body = body
    }
    
    public static var invalidURL: RequestError {
        .init(statusCode: -1, body: "Invalid Url")
    }
    
    public static var noData: RequestError {
        .init(statusCode: -1, body: "No Data")
    }
    
    public static var unknown: RequestError {
        .init(statusCode: -1, body: "Unknown Error")
    }
    
    public static var noResponse: RequestError {
        .init(statusCode: -1, body: "No Response")
    }
    
    public static var decode: RequestError {
        .init(statusCode: -1, body: "Decode Error")
    }
    
    public static func unknown(_ err: Error) -> RequestError {
        .init(statusCode: -1, body: err.localizedDescription)
    }
    
    public var message: String {
        return body
    }
}
