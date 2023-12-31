//
//  Result+.swift
//  
//
//  Created by Kemal Türk on 25.10.2022.
//

import Foundation

public extension Result {
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var value: Success? {
        switch self {
        case .success(let success):
            return success
        case .failure:
            return nil
        }
    }
    
    var error: Failure? {
        switch self {
        case .success:
            return nil
        case .failure(let failure):
            return failure
        }
    }
    
}

public extension Result where Failure == RequestError {
    func toFetchState() -> FetchState<Success> {
        switch self {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
