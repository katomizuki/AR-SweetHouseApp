//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/15.
//

import SceneKit
import SwiftUI

struct SweetSceneView: UIViewRepresentable {
    @Binding var scene: SCNScene?
    typealias UIViewType = SCNView
    
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
}
