//
//  HttpClient.swift
//  
//
//  Created by Kemal Türk on 28.07.2022.
//

import Foundation

public protocol HTTPClient {
    func sendPlainRequest(endpoint: Endpoint) async -> Result<Data, RequestError>
    func sendRequest<T: Decodable>(endpoint: Endpoint) async -> Result<T, RequestError>
    func sendRequest<T: Decodable>(session: HttpSession) async -> Result<T, RequestError>
    
    func handleError<T: Decodable>(_ session: HttpSession) async -> Result<T, RequestError>?
}

public extension HTTPClient {
    func sendPlainRequest(endpoint: Endpoint) async -> Result<Data, RequestError> {
        let plainRequest = PlainRequest()
        return await withTaskCancellationHandler {
            return await withCheckedContinuation { continuation in
                plainRequest.start(endpoint: endpoint, continuation: continuation)
            }
        } onCancel: {
            plainRequest.cancel()
        }
    }
    
    func sendRequest<T: Decodable>(endpoint: Endpoint) async -> Result<T, RequestError> {
        await sendRequest(session: .init(endpoint: endpoint))
    }
    
    func sendRequest<T: Decodable>(session: HttpSession) async -> Result<T, RequestError> {
        let result = await sendPlainRequest(endpoint: session.endpoint)
        switch result {
        case .success(let data):
            let dataStr = String(data: data, encoding: .utf8)
            if T.self == AnyResponseModel.self {
                return .success(AnyResponseModel(data: dataStr) as! T)
            }
            
            if T.self == String.self {
                return .success((dataStr ?? "") as! T)
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedResponse)
            } catch {
                print("***DECODE ERROR***")
                print(String(describing: T.self))
                print(error)
                return .failure(.decode)
            }
        case .failure(let error):
            session.error = error
            return await handleError(session) ?? .failure(error)
        }
    }
    
    func handleError<T>(_ session: HttpSession) async -> Result<T, RequestError>? where T : Decodable {
        return nil
    }
}

fileprivate class PlainRequest {
    
    private var task: URLSessionTask?
    
    func start(endpoint: Endpoint, continuation: CheckedContinuation<Result<Data, RequestError>, Never>) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.middlePath + endpoint.path
        
        if endpoint.host.contains(":") {
            let parts = endpoint.host.split(separator: ":").map { String($0) }
            urlComponents.host = parts.first
            urlComponents.port = Int(parts.last ?? "")
        }
        
        if let query = endpoint.query {
            urlComponents.queryItems = query.map({(key, val) in
                URLQueryItem(name: key, value: val)
            })
        }
        
        guard let url = urlComponents.url else {
            return continuation.resume(returning: .failure(.invalidURL))
        }
        
        var header = endpoint.header
        header?["Content-Type"] = endpoint.contentType.rawValue
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = header
        request.timeoutInterval = endpoint.timeout
        
        if let body = endpoint.body {
            if endpoint.contentType == .xwwwformurlencoded {
                request.httpBody = body.toUrlComponentsData()
            } else {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        if endpoint.method != .get, let formData = endpoint.formData {
            let multipartFormDataRequest = MultipartFormDataRequest()
            multipartFormDataRequest.addFieldsFrom(formData)
            multipartFormDataRequest.bindToRequest(&request)
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, RequestError> = .failure(.unknown)
            defer {
                continuation.resume(returning: result)
            }
            
            if let error {
                print(error)
                return result = .failure(.unknown(error))
            }
            guard let response = response as? HTTPURLResponse else {
                return result = .failure(.noResponse)
            }
            
            var responseRawBody = ""
            if let data {
                responseRawBody = String(data: data, encoding: .utf8) ?? "Empty!!!"
            }
            
            Self.log(url, endpoint, response, responseRawBody)
            
            switch response.statusCode {
            case 200...299:
                guard let data = data else {
                    return result = .failure(.noData)
                }
                return result = .success(data)
            default:
                return result = .failure(.init(statusCode: response.statusCode, body: responseRawBody))
            }
        }
        
        task!.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private class func log(_ url: URL, _ endpoint: Endpoint, _ response: HTTPURLResponse, _ responseRawBody: String) {
        print("*********************")
        print("*** RESPONSE DATA ***")
        print("*********************")
        print("Status Code: \(response.statusCode)")
        print("URL: \(url)")
        print("Method: \(endpoint.method.rawValue)")
        
        if let headers = endpoint.header {
            print("Headers: \(String(describing: headers))")
        }
        
        if let formData = endpoint.formData {
            print("Request: \(String(describing: formData))")
        }
        
        if let body = endpoint.body {
            print("Request: \(String(describing: body))")
        }
        
        print("Response: \(responseRawBody)")
        print("*********************")
        print("***      END      ***")
        print("*********************")
    }
    
}

fileprivate extension Dictionary where Key == String {
    func toUrlComponentsData() -> Data? {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = self.map { (key, value) in
            return URLQueryItem(name: key, value: "\(String(describing: value))")
        }
        return requestBodyComponents.query?.data(using: .utf8)
    }
}
