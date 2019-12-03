//
//  Heap.swift
//  Created by Arthur Dexter on 12/3/19.
//

import Foundation

public struct Heap<Element>: CustomDebugStringConvertible {

    public init<S: Sequence>(_ elements: S, compare: @escaping (Element, Element) -> Bool) where S.Element == Element {
        self.compare = compare
        self.elements = []
        for element in elements {
            push(element)
        }
    }

    public init(compare: @escaping (Element, Element) -> Bool) {
        self.init([], compare: compare)
    }

    public var isEmpty: Bool {
        return elements.isEmpty
    }

    public var count: Int {
        return elements.count
    }

    public mutating func push(_ element: Element) {
        elements.append(element)
        siftUp(at: elements.count - 1)
    }

    public var peek: Element? {
        return elements.first
    }

    @discardableResult
    public mutating func pop() -> Element? {
        guard let result = elements.first else {
            return nil
        }

        let lastElement = elements.removeLast()
        if !elements.isEmpty {
            elements[0] = lastElement
            siftDown(at: 0)
        }

        return result
    }

    public var debugDescription: String {
        func nodeDescription(at index: Int) -> String? {
            guard index < elements.count else {
                return nil
            }
            let element = elements[index]
            let leftDescription = nodeDescription(at: leftChildIndex(of: index))
            let rightDescription = nodeDescription(at: rightChildIndex(of: index))
            return "(\(element) \(leftDescription ?? "nil") \(rightDescription ?? "nil"))"
        }
        return "Heap<\(nodeDescription(at: 0) ?? "nil")>"
    }

    private let compare: (Element, Element) -> Bool
    private var elements: [Element]

    private func parentIndex(of index: Int) -> Int {
        return index / 2
    }

    private func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }

    private mutating func siftUp(at index: Int) {
        var child = index
        var parent = parentIndex(of: child)
        while parent != child {
            if compare(elements[child], elements[parent]) {
                elements.swapAt(parent, child)
                child = parent
                parent = parentIndex(of: child)
            } else {
                break
            }
        }
    }

    private mutating func siftDown(at index: Int) {
        var index = index
        repeat {
            var j = -1
            let right = rightChildIndex(of: index)
            if right < elements.count, compare(elements[right], elements[index]) {
                let left = leftChildIndex(of: index)
                if compare(elements[left], elements[right]) {
                    j = left
                } else {
                    j = right
                }
            } else {
                let left = leftChildIndex(of: index)
                if left < elements.count, compare(elements[left], elements[index]) {
                    j = left
                }
            }
            if j >= 0 {
                elements.swapAt(index, j)
            }
            index = j
        } while index >= 0
    }
}

extension Heap where Element: Comparable {

    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        self.init(elements, compare: <)
    }

    public init() {
        self.init([])
    }
}
