//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/12.
//
import Foundation
import SwiftUI
import RealityKit
import ThumbnailGeneratorFeature

public struct Sweet: Identifiable, CustomStringConvertible, Hashable, Codable {
    
    public var id: String = UUID().uuidString
    public let name: String
    public let thumbnail: String
    public var description: String
    public var entity: Entity?
    
    public init(name: String, thumbnail: String, description: String) {
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        self.entity = try? ModelEntity.load(named: name)
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Sweet, rhs: Sweet) -> Bool {
            return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case thumbnail
        case description
    }
}
