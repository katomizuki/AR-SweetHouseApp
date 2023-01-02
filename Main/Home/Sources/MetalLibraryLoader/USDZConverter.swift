//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/02.
//

import SceneKit.ModelIO

final class ScnGenerator {
    static func generate(_ url: URL) -> SCNScene {
        let mdlAsset = MDLAsset(url: url)
        let scnScene = SCNScene(mdlAsset: mdlAsset)
        return scnScene
    }
}
