//
//  FormDataEncodable.swift
//  
//
//  Created by Kemal Türk on 3.11.2022.
//

import Foundation


protocol FormDataEncodable: Encodable {
    func toFormData() -> [FormData]
}

extension FormDataEncodable {
    func toFormData() -> [FormData] {
        if let dict = self.toDict() {
            var body = [FormData]()
            dict.keys.forEach { (key) in
                let value = dict[key]
                
                if let val = (value as? [String]) {
                    val.forEach { item in
                        body.appendText(key: "\(key)[]", value: item)
                    }
                } else {
                    var strValue = ""
                    if let val = (value as? String) {
                        strValue = val
                    } else if let val = (value as? Int) {
                        strValue = String(val)
                    } else if let val = (value as? Double) {
                        strValue = String(val)
                    } else if let val = (value as? Bool) {
                        strValue = val ? "1" : "0"
                    }
                    
                    body.appendText(key: key, value: strValue)
                }
            }
            return body
        }
        return []
    }
}
