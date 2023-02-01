//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/09.
//

import RealityKit
import ARKit

public final class ARSceneSetting {
    public static var sceneMode: ARSceneMode = .objectPutting
    public static var isAllowHaptics: Bool = true
    public static var selectedModel: Entity?
    public static var currentAnchorState: AddAnchor = .normal
    public static var savedARWorldMap: ARWorldMap?
    public static var isRevive: Bool = false
    public enum AddAnchor {
        // ObjectPutting->RoomPlanに途中できりかえ
        case objToRoom
        // anchorを配置し終わった後の状態
        case finishAddAnchor
        // 通常状態
        case normal
    }
    
    public static var connectText: String = ""
    public enum ConnectionStatus {
        case connecting
        case noConnecting
        case invite
    }
    
}
