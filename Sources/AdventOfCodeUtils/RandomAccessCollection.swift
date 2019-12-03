//
//  RandomAccessCollection.swift
//  Created by Arthur Dexter on 12/3/19.
//

import Foundation

extension RandomAccessCollection {

    public var combinations: [[Element]] {
        var result: [[Element]] = []

        let numberOfCombinations = 1 << self.count
        result.reserveCapacity(numberOfCombinations)

        for n in 0..<numberOfCombinations {
            let combinationIndexes: [Int] = n.indexesOfSetBits
            let combination: [Element] = combinationIndexes.map { offset in
                let index = self.index(self.startIndex, offsetBy: offset)
                return self[index]
            }
            result.append(combination)
        }
        return result
    }
}
