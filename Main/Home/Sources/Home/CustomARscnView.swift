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
        setupRoomCaptureDelegate()
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
        sceneView.scene = SCNScene()
        sceneView.automaticallyUpdatesLighting = true
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
        var config = RoomCaptureSession.Configuration()
        config.isCoachingEnabled = true
        caputureSession.run(configuration: config)
    }
    
    private func stopCaptureSession() {
        caputureSession.stop()
    }
    
    private func removeObjectNodes(with room: CapturedRoom) {
        room.objects.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            viewStore.send(.removeRoomNode(roomNode))
        }
    }
    
    private func changeObjectNodes(with room: CapturedRoom) {
        room.objects.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            
        }
    }
    
    private func addObjectNodes(with room: CapturedRoom) {
        room.objects.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            viewStore.send(.addRoomNode(roomNode))
        }
    }
    
    private func updateObjectNodes(with room: CapturedRoom) {
        room.objects.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            
        }
    }
}

extension CustomARScnViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        viewStore.state.roomNodes.forEach({
            $0.updateAt(time: time)
        })
    }
}

extension CustomARScnViewController: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        print(#function)
        self.addObjectNodes(with: room)
    }
    
    func captureSession(_ session: RoomCaptureSession, didRemove room: CapturedRoom) {
        print(#function)
        self.removeObjectNodes(with: room)
    }
    
    func captureSession(_ session: RoomCaptureSession, didProvide instruction: RoomCaptureSession.Instruction) {
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        print(#function)
        self.updateObjectNodes(with: room)
    }
    
    func captureSession(_ session: RoomCaptureSession, didChange room: CapturedRoom) {
        print(#function)
        self.changeObjectNodes(with: room)
    }
    
    func captureSession(_ session: RoomCaptureSession, didStartWith configuration: RoomCaptureSession.Configuration) {
        print(#function)
        sceneView.session = session.arSession
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
