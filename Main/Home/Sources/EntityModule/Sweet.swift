//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/12.
//
import Foundation
import SwiftUI

public struct Sweet: Identifiable, CustomStringConvertible {
    
    public let id: String = UUID().uuidString
    public let name: String
    public let thumnail: Image
    public var description: String
    
    public init(name: String, thumnail: Image, description: String) {
        self.name = name
        self.thumnail = thumnail
        self.description = description
    }
}
