//
//  Endpoint.swift
//
//
//  Created by Kemal Türk on 30.09.2023.
//

import Foundation


public extension Endpoint {
    var url: URL? { nil }
    var scheme: String { "https" }
    var contentType: ContentType { .json }
    var middlePath: String { "" }
    var header: [String : String]? { nil }
    var body: [String : Any]? { nil }
    var formData: [FormData]? { nil }
    var query: [String : String]? { nil }
    var timeout: TimeInterval { 10 }
}
