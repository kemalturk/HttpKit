//
//  Endpoint.swift
//  
//
//  Created by Kemal Türk on 28.07.2022.
//

import Foundation


protocol HttpEndpoint {
  var scheme: String { get }
  var host: String { get }
  var contentType: ContentType { get }
  var middlePath: String { get }
  var path: String { get }
  var method: RequestMethod { get }
  var header: [String: String]? { get }
  var body: [String: Any]? { get }
  var formData: [FormData]? { get }
  var query: [String: String]? { get }
  var timeout: TimeInterval { get }
}

enum FormData {
  case text(key: String, value: String)
  case image(key: String, fileName: String, mimeType: MimeType, data: Data)
}

enum MimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
}

extension Array where Element == FormData {
  mutating func appendText(key: String, value: String) {
    self.append(.text(key: key, value: value))
  }
  
  mutating func append(_ formDataEncodable: FormDataEncodable) {
    self.append(contentsOf: formDataEncodable.toFormData())
  }
}
