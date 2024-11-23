//
//  HttpSession.swift
//  Thor
//
//  Created by Kemal Türk on 8.07.2023.
//  Copyright © 2023 4A Labs. All rights reserved.
//

import Foundation


public class HttpSession {
    var endpoint: Endpoint
    var error: RequestError?
    var payload: [String:Any]
    
    public init(endpoint: Endpoint, error: RequestError? = nil, payload: [String:Any] = [:]) {
        self.endpoint = endpoint
        self.error = error
        self.payload = payload
    }
}
