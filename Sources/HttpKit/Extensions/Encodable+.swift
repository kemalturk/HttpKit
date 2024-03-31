//
//  Encodable+.swift
//
//
//  Created by Kemal Türk on 31.03.2024.
//

import Foundation

extension Encodable {
    public func toDict() -> [String: Any]? {
        if let encoded = try? JSONEncoder().encode(self) {
            return try? JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        }
        return nil
    }
}
