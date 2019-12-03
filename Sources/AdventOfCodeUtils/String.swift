//
//  String.swift
//  Created by Arthur Dexter on 12/3/19.
//

import Foundation

extension StringProtocol {

    public var lines: [String] {
        var result: [String] = []
        self.enumerateLines { line, _ in result.append(line) }
        return result
    }

    public func split<S: StringProtocol>(separator: S, maxSplit: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [Self.SubSequence] {
        var result: [Self.SubSequence] = []
        var index = self.startIndex
        while index < self.endIndex {
            if let separatorRange = self.range(of: separator, range: index..<self.endIndex) {
                result.append(self[index..<separatorRange.lowerBound])
                index = separatorRange.upperBound
            } else {
                break
            }
        }
        if index < self.endIndex {
            result.append(self[index..<self.endIndex])
        }
        return result
    }
}
