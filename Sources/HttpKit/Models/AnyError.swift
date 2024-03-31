//
//  AnyError.swift
//
//
//  Created by Kemal Türk on 24.10.2022.
//

import Foundation

struct AnyError {
  let message: String
}

extension AnyError: LocalizedError {
  var errorDescription: String? { message }
  
}
