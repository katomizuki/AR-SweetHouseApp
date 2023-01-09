//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/09.
//

import RealityKit
import ARKit

public final class UserSetting {
    public static var sceneMode: ARSceneMode = .objectPutting
    public static var isAllowHaptics: Bool = true
    public static var isAllowMotion: Bool = true
    public static var selectedModel: ModelEntity?
}
