//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/07.
//

import SceneKit
import RoomPlan

public final class RoomNode: Hashable, Equatable {
   
    private var boxNode: SCNNode = SCNNode()
    private let roomObject: RoomObjectAnchor
    private let uuid: String
    
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
    func updateAt(time: TimeInterval) {
        update(with: roomObject.dimensions, category: roomObject.category)
        boxNode.simdTransform = roomObject.transform
    }

    func update(with dimensions: simd_float3,
                category: CapturedRoom.Object.Category?) {
        let width = CGFloat(dimensions.x)
        let height = CGFloat(dimensions.y)
        let length = CGFloat(dimensions.z)
        let boxColor = UIColor.green
        let boxGeometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = boxColor
        boxNode.geometry = boxGeometry
    }
}

