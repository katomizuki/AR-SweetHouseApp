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
import RoomPlan

final class CustomARScnViewController: UIViewController {
    private let sceneView = ARSCNView()
    private let viewStore: ViewStoreOf<ARScnFeature>
    private lazy var caputureSession: RoomCaptureSession = {
        let captureSession = RoomCaptureSession()
        sceneView.session = captureSession.arSession
        return captureSession
    }()
    private let roomBuilder = RoomBuilder(options: [.beautifyObjects])
    
    init(store: StoreOf<ARScnFeature>) {
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
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
    
    private func setupRoomCaptureDelegate() {
        caputureSession.delegate = self
        caputureSession.run(configuration: .init())
    }
}

extension CustomARScnViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
}

extension CustomARScnViewController: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        let roomObjectAnchors = room.objects.map { RoomObjectAnchor($0) }
        //        roomObjectAnchors[0]
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didRemove room: CapturedRoom) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didProvide instruction: RoomCaptureSession.Instruction) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didChange room: CapturedRoom) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didStartWith configuration: RoomCaptureSession.Configuration) {
        print(#function)
    }
    
    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: Error?) {
        if error != nil {
            viewStore.send(.showFailedAlert)
            return
        }
        Task {
            do {
                let finalRoom = try await roomBuilder.capturedRoom(from: data)
            } catch {
                viewStore.send(.showFailedAlert)
            }
        }
    }
}
