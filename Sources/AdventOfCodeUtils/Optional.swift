//
//  Optional.swift
//  
//
//  Created by Arthur Dexter on 12/3/19.
//

import Foundation

extension Optional {

    public func required() throws -> Wrapped {
        switch self {
        case let .some(value):
            return value
        case .none:
            throw RequiredOptionalValueMissingError()
        }
    }
}

public struct RequiredOptionalValueMissingError: Error {}
