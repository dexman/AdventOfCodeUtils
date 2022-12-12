//
//  AStar.swift
//  Created by Arthur Dexter on 12/3/19.
//

import Foundation

/// aStar finds a path from start to goal.
/// distance(current,neighbor) is the weight of the edge from current to neighbor
/// heuristicDistance is the heuristic function. h(n) estimates the cost to reach goal from node n.
public func aStar<Node: Hashable>(
    start: Node,
    goal: (Node) -> Bool,
    distance: (Node, Node) -> Int,
    heuristicDistance: (Node) -> Int,
    neighbors: (Node) -> Set<Node>
) -> [Node]? {
    // https://en.wikipedia.org/wiki/A*_search_algorithm

    func reconstructPath<Node: Hashable>(_ cameFrom: [Node: Node], _ current: Node) -> [Node] {
        var current = current
        var totalPath: [Node] = [current]
        while let next = cameFrom[current] {
            current = next
            totalPath.append(current)
        }
        return totalPath.reversed()
    }

    // For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start to n currently known.
    var cameFrom: [Node: Node] = [:]

    // For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
    var gScore: [Node: Int] = [start: 0]

    // For node n, fScore[n] := gScore[n] + h(n).
    var fScore: [Node: Int] = [start: heuristicDistance(start)]

    // The set of discovered nodes that may need to be (re-)expanded.
    // Initially, only the start node is known.
    var openSet: Heap<Node> = Heap([start]) { fScore[$0, default: Int.max] < fScore[$1, default: Int.max] }

    // Track the elements in openSet for `contains` operations.
    var openSetElements: Set<Node> = [start]

    while let current = openSet.peek {
        // current is the node in openSet having the lowest fScore[] value

        if goal(current) {
            return reconstructPath(cameFrom, current)
        }

        openSet.pop()
        openSetElements.remove(current)

        for neighbor in neighbors(current) {
            // tentative_gScore is the distance from start to the neighbor through current
            let tentative_gScore = gScore[current, default: Int.max] + distance(current, neighbor)
            if tentative_gScore < gScore[neighbor, default: Int.max] {
                // This path to neighbor is better than any previous one. Record it!
                cameFrom[neighbor] = current
                gScore[neighbor] = tentative_gScore
                fScore[neighbor] = gScore[neighbor, default: Int.max] + heuristicDistance(neighbor)
                if !openSetElements.contains(neighbor) {
                    openSet.push(neighbor)
                    openSetElements.insert(neighbor)
                }
            }
        }
    }

    // Open set is empty but goal was never reached
    return nil
}

public func aStar<Node: Hashable>(
    start: Node,
    goal: Node,
    distance: (Node, Node) -> Int,
    heuristicDistance: (Node) -> Int,
    neighbors: (Node) -> Set<Node>
) -> [Node]? {
    aStar(
        start: start,
        goal: { $0 == goal },
        distance: distance,
        heuristicDistance: heuristicDistance,
        neighbors: neighbors
    )
}
