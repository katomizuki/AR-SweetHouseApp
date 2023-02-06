//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/12.
//
import Foundation
import SwiftUI
import RealityKit

public struct Sweet: Identifiable, CustomStringConvertible, Hashable, Codable {
    
    public var id: UUID = UUID()
    public let name: String
    public var description: String
    public var usdzName: String
    public var entity: Entity?
    
    public init(name: String,
                description: String,
                usdzName: String,
                scale: Float) {
        self.name = name
        self.description = description
        self.usdzName = usdzName
    #if targetEnvironment(simulator)
    #else
        self.entity = try? ModelEntity.load(named: usdzName)
        self.entity?.scale = simd_make_float3(scale, scale, scale)
    #endif
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Sweet, rhs: Sweet) -> Bool {
            return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case usdzName
    }
}
