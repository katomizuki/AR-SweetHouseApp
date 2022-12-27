//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/12.
//
import Foundation
import SwiftUI

public struct Sweet: Identifiable, CustomStringConvertible, Hashable, Codable {
    
    public var id: String = UUID().uuidString
    public let name: String
    public let thumnail: String
    public var description: String
    
    public init(name: String, thumnail: String, description: String) {
        self.name = name
        self.thumnail = thumnail
        self.description = description
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Sweet, rhs: Sweet) -> Bool {
            return lhs.id == rhs.id
    }
}
