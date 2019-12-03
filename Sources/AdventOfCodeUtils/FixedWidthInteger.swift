//
//  FixedWidthInteger.swift
//  Created by Arthur Dexter on 12/3/19.
//

import Foundation

extension FixedWidthInteger {

    public static func parse<S: StringProtocol>(_ text: S, radix: Int = 10) throws -> Self {
        guard let value = Self(text, radix: radix) else {
            throw ParseError<Self>(text)
        }
        return value
    }

    public var indexesOfSetBits: [Int] {
        var result: [Int] = []

        // https://lemire.me/blog/2018/02/21/iterating-over-set-bits-quickly/
        var bitset = self
        while bitset != 0 {
            let t = bitset & (-1 * bitset)
            let r = bitset.trailingZeroBitCount
            if r < self.bitWidth {
                result.append(r)
            }
            bitset ^= t
        }

        return result
    }
}

extension FixedWidthInteger where Self: CVarArg {

    public var hexString: String {
        let padding = 2 * MemoryLayout<Self>.size
        return String(format: "%0\(padding)x", self)
    }
}
