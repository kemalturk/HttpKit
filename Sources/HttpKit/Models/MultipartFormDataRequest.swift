//
//  MultipartFormDataRequest.swift
//  
//
//  Created by Kemal Türk on 24.10.2022.
//

import Foundation

struct MultipartFormDataRequest {
  private let boundary: String = UUID().uuidString
  private var httpBody = NSMutableData()
  
  func addTextField(named name: String, value: String) {
    httpBody.append(textFormField(named: name, value: value))
  }
  
  func addFieldsFrom(_ formDatas: [FormData]) {
    formDatas.forEach { item in
      switch item {
      case .text(key: let key, value: let value):
        addTextField(named: key, value: value)
      case .image(key: let key, fileName: let fileName, mimeType: let mimeType, data: let data):
        addDataField(named: key, filename: fileName, data: data, mimeType: mimeType)
      }
    }
  }
  
  private func textFormField(named name: String, value: String) -> String {
    var fieldString = "--\(boundary)\r\n"
    fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
    fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
    fieldString += "Content-Transfer-Encoding: 8bit\r\n"
    fieldString += "\r\n"
    fieldString += value
    fieldString += "\r\n"
    
    return fieldString
  }
  
  func addDataField(named name: String, filename: String, data: Data, mimeType: MimeType) {
    httpBody.append(dataFormField(named: name, filename: filename, data: data, mimeType: mimeType))
  }
  
  private func dataFormField(named name: String,
                             filename: String,
                             data: Data,
                             mimeType: MimeType) -> Data {
    let fieldData = NSMutableData()
    
    fieldData.append("--\(boundary)\r\n")
    fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
    fieldData.append("Content-Type: \(mimeType.rawValue)\r\n")
    fieldData.append("\r\n")
    fieldData.append(data)
    fieldData.append("\r\n")
    
    return fieldData as Data
  }
  
  func bindToRequest(_ request: inout URLRequest) {
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    httpBody.append("--\(boundary)--")
    request.httpBody = httpBody as Data
  }
}

fileprivate extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
