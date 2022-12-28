//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/28.
//

import ARKit
import RealityKit

final class SweetObjectAnchor: ARAnchor {
    private var sweetName: String
    private var sweetTransform: simd_float4x4
    private var sweetId: String
    
    required init(anchor: ARAnchor) {
        self.sweetTransform = anchor.transform
        self.sweetName = anchor.name ?? ""
        self.sweetId = anchor.identifier.uuidString
        super.init(transform: anchor.transform)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
