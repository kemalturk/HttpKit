//
//  Endpoint+HttpClient.swift
//  
//
//  Created by Kemal Türk on 9.04.2023.
//

import Foundation


private struct HttpClientWrapper: HTTPClient {
    func handleError<T>(_ session: HttpSession) async -> Result<T, RequestError>? where T : Decodable {
        return nil
    }
}

extension Endpoint {
  func sendRequest<T: Decodable>() async -> Result<T, RequestError> {
    await HttpClientWrapper().sendRequest(endpoint: self)
  }
  
  func sendPlainRequest() async -> Result<Data, RequestError> {
    await HttpClientWrapper().sendPlainRequest(endpoint: self)
  }
}

