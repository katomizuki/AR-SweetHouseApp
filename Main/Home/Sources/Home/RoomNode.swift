//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/07.
//

import RoomPlan
import RealityKit
import ARKit

public final class RoomNode: Hashable, Equatable {
   
    var anchorEntity = AnchorEntity()
    let roomObject: RoomObjectAnchor
    let uuid: String
    
    init(roomObject: RoomObjectAnchor,uuid: String) {
        self.roomObject = roomObject
        self.uuid = uuid
    }

    public static func == (lhs: RoomNode, rhs: RoomNode) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
extension RoomNode {
    func updateObject() {
        update(with: roomObject.dimensions, category: roomObject.category)
        anchorEntity.transform = Transform(matrix: roomObject.transform)
    }
    
    func updateSurface() {
        update(with: roomObject.dimensions, surface: roomObject.surfaceCategory)
        anchorEntity.transform = Transform(matrix: roomObject.transform)
    }
    
    func update(with dimensions: simd_float3, surface: CapturedRoom.Surface.Category) {
        DispatchQueue.main.async {
            let mesh = MeshResource.generateBox(size: dimensions)
            var material = SimpleMaterial()
            switch surface {
            case .wall:
                material.color.texture = .init(self.makeTexture(name: "cookie"))
            case .opening:
                material.color.texture = .init(self.makeTexture(name: "whitechocolate"))
            case .window:
                material.color.texture = .init(self.makeTexture(name: "chocolate"))
            case .door(_):
                material.color.texture = .init(self.makeTexture(name: "candy"))
            @unknown default:
                fatalError()
            }
            self.anchorEntity.addChild(ModelEntity(mesh: mesh,materials: [material]))
        }
    }
    
    private func makeTexture(name: String) -> TextureResource {
        return try! TextureResource.load(named: name)
    }

    func update(with dimensions: simd_float3,
                category: CapturedRoom.Object.Category?) {
        DispatchQueue.main.async {
            let mesh = MeshResource.generateBox(size: dimensions)
            var material = SimpleMaterial()
            switch self.roomObject.category {
            case .storage:
                material.color.texture = .init(self.makeTexture(name: "cookie"))
            case .television:
                material.color.texture = .init(self.makeTexture(name: "chocolate"))
            case .refrigerator:
                material.color.texture = .init(self.makeTexture(name: "candy"))
            case .bed:
                material.color.texture = .init(self.makeTexture(name: "chocolate"))
            case .table:
                material.color.texture = .init(self.makeTexture(name: "whitechocolate"))
            default: break
            }
            self.anchorEntity.addChild(ModelEntity(mesh: mesh,materials: [material]))
        }
    }
}

