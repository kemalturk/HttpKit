//
//  ContentType.swift
//  Thor
//
//  Created by Kemal Türk on 3.07.2023.
//  Copyright © 2023 4A Labs. All rights reserved.
//

import Foundation

public enum ContentType : String {
    case json               = "application/json"
    case xwwwformurlencoded = "application/x-www-form-urlencoded"
    case multipartFormData  = "multipart/form-data"
}
