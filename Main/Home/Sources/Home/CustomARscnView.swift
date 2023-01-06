//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/06.
//

import UIKit
import SceneKit
import ARKit
import SwiftUI
import ComposableArchitecture

final class CustomARScnViewController: UIViewController {
    private let sceneView = ARSCNView()
    private let viewStore: ViewStoreOf<ARScnFeature>
    
    init(store: StoreOf<ARScnFeature>) {
        self.viewStore = ViewStore(store)
        super.init()
        setUp()
    }
    
    private func setUp() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomARScnViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
}
