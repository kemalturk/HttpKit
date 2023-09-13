//
//  HttpSession.swift
//  Thor
//
//  Created by Kemal Türk on 8.07.2023.
//  Copyright © 2023 4A Labs. All rights reserved.
//

import Foundation


class HttpSession {
    var endpoint: HttpEndpoint
    var error: RequestError?
    var refreshToken: Bool
    
    init(endpoint: HttpEndpoint, error: RequestError? = nil, refreshToken: Bool) {
        self.endpoint = endpoint
        self.error = error
        self.refreshToken = refreshToken
    }
}
