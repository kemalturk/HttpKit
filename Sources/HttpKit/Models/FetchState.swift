//
//  State.swift
//  
//
//  Created by Kemal Türk on 19.10.2022.
//

import Foundation

/// loading should hold latest success value if possible
public enum FetchState<Value> {
  case initial
  case loading
  case success(Value)
  case failure(RequestError)
}

public extension FetchState {
  
  var isInitial: Bool {
    switch self {
    case .initial:
      return true
    default:
      return false
    }
  }
  
  var isLoading: Bool {
    switch self {
    case .loading:
      return true
    default:
      return false
    }
  }
  
  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    default:
      return false
    }
  }
  
  var isFailure: Bool {
    switch self {
    case .failure:
      return true
    default:
      return false
    }
  }
  
  var value: Value? {
    switch self {
    case .success(let val):
      return val
    default:
      return nil
    }
  }
  
  var error: RequestError? {
    switch self {
    case .failure(let error):
      return error
    default:
      return nil
    }
  }
  
}

extension FetchState: Equatable {
  public static func == (lhs: FetchState<Value>, rhs: FetchState<Value>) -> Bool {
    switch(lhs, rhs) {
    case (.initial, .initial):
      return true
    case (.loading, .loading):
      return true
    case (.success(_), .success(_)):
      return true
    case (.failure(_), .failure(_)):
      return true
    default:
      return false
    }
  }
}
