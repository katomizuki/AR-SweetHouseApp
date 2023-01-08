//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/07.
//

import SceneKit
import RoomPlan

public final class RoomNode: Hashable, Equatable {
   
    var boxNode: SCNNode = SCNNode()
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
    func updateAt() {
        update(with: roomObject.dimensions, category: roomObject.category)
        boxNode.simdTransform = roomObject.transform
    }

    func update(with dimensions: simd_float3,
                category: CapturedRoom.Object.Category?) {
        let width = CGFloat(dimensions.x)
        let height = CGFloat(dimensions.y)
        let length = CGFloat(dimensions.z)
        let boxGeometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        let material = SCNMaterial()
        switch roomObject.category {
        case .storage:
            material.diffuse.contents = UIImage(named: "cookie")
        case .television:
            material.diffuse.contents = UIImage(named: "chocolate")
        case .refrigerator:
            material.diffuse.contents = UIImage(named: "candy")
        case .bed:
            material.diffuse.contents = UIImage(named: "chocolate")
        case .table:
            material.diffuse.contents = UIImage(named: "whitechocolate")
        case .sofa:
            material.diffuse.contents = UIImage(named: "candy")
        default: break
        }
        
        boxGeometry.firstMaterial? = material
        boxNode.opacity = 1.0
        boxNode.geometry = boxGeometry
    }
}

