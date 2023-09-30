//
//  RequestError.swift
//  
//
//  Created by Kemal Türk on 28.07.2022.
//

import Foundation

public struct RequestError: Error {
  let statusCode: Int
  let body: String
  
  static var invalidURL: RequestError {
    .init(statusCode: -1, body: "Invalid Url")
  }
  
  static var noData: RequestError {
    .init(statusCode: -1, body: "No Data")
  }
  
  static var unknown: RequestError {
    .init(statusCode: -1, body: "Unknown Error")
  }
  
  static var noResponse: RequestError {
    .init(statusCode: -1, body: "No Response")
  }
  
  static var decode: RequestError {
    .init(statusCode: -1, body: "Decode Error")
  }
  
  static func unknown(_ err: Error) -> RequestError {
    .init(statusCode: -1, body: err.localizedDescription)
  }
  
  var message: String {
    return body
  }
}
