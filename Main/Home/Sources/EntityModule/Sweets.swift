//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/12.
//

import Foundation
import SwiftUI


public struct Sweets {
    
    public let list: [Sweet] = [
        Sweet(name: "cupcake", thumbnail: "cupcake", description: "カップケーキ"),
        Sweet(name: "cookie", thumbnail: "cookie", description: "クッキー"),
        Sweet(name: "chocolate", thumbnail: "cookie", description: "チョコレート"),
        Sweet(name: "iceCream", thumbnail: "iceCream", description: "アイスクリーム"),
        Sweet(name: "donut", thumbnail: "donut", description: "ドーナッツ"),
    ]
    
    public init() { }
}

extension Sweets: Collection {
    
    public typealias Element = Sweet
    public typealias Index = Int
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return list.count }
    
    public subscript(position: Int) -> Sweet { return list[position] }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
}

extension Sweets: Equatable {
    public static func == (lhs: Sweets, rhs: Sweets) -> Bool {
        return true
    }
}
