//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/12.
//

import Foundation
import SwiftUI

public struct Sweets {
    public let list: [Sweet]
    
    public init(list: [Sweet]) {
        self.list = list
    }
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
