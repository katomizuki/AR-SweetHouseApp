//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ARKit
import RealityKit
import CoachingOverlayFeature
import Combine
import RoomPlan
import FocusEntity
import ComposableArchitecture
import EntityModule

final class HomeARView: ARView {
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewStore: ViewStoreOf<ARFeature>
    private lazy var focusEntity: FocusEntity = {
        FocusEntity(on: self,
                    style: .classic(color: .orange))
    }()
    private lazy var caputureSession: RoomCaptureSession = {
        let captureSession = RoomCaptureSession()
        return captureSession
    }()
    
    required init(store: StoreOf<ARFeature>) {
        self.viewStore = ViewStore(store)
        super.init(frame: .zero)
        viewStore.send(.initialize)
        setupSessionDelegate()
        setupConfiguration()
        setupOverlayView()
        setupSubscribeARScene()
        setupTouchUpEvent()
        setupRoomCaptureDelegate()
    }
    
    private func setupSessionDelegate() {
        session.delegate = self
    }
    
    private func setupTouchUpEvent() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(onTouchARView))
        self.addGestureRecognizer(touchGesture)
    }
    
    @objc private func onTouchARView(_ sender: UITapGestureRecognizer) {
        if ARSceneSetting.sceneMode == .roomPlan { return }
        let tapPoint = sender.location(in: self)
        guard let rayResults = ray(through: tapPoint) else { return }
        let hitResults = scene.raycast(from: rayResults.origin, to: rayResults.direction)
        if let collisionPoint = hitResults.first {
            var position = collisionPoint.position
            position.y += 0.15
        } else {
            let results = raycast(from: tapPoint, allowing: .estimatedPlane, alignment: .horizontal)
            if let hitPoint = results.first {
                let position = simd_make_float3(hitPoint.worldTransform.columns.3)
                putSweet(at: position)
            }
        }
    }
    
    private func putSweet(at position: simd_float3) {
        guard let selectedModel = ARSceneSetting.selectedModel else { return }
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(selectedModel)
        scene.anchors.append(anchorEntity)
        viewStore.send(.onTouchARView)
    }
    
    private func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) && ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.sceneReconstruction = [.meshWithClassification]
            configuration.frameSemantics = [.sceneDepth]
            configuration.planeDetection = [.horizontal, .vertical]
        }
        session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    private func setupOverlayView() {
        let overlayFeature = CoachingOverlayFeature(session: session)
        overlayFeature.setupOverlayView(view: self)
    }
    
    private func setupRoomCaptureDelegate() {
        caputureSession.delegate = self
        var config = RoomCaptureSession.Configuration()
        config.isCoachingEnabled = true
        caputureSession.run(configuration: config)
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func setupSubscribeARScene() {
        scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
            guard let self = self else { return }
            self.viewStore.send(.subscriveEvent(session: self.session,
                                                 roomSession: self.caputureSession))
            if let worldMap = ARSceneSetting.savedARWorldMap,
               ARSceneSetting.isRevive {
                let configuration = ARWorldTrackingConfiguration()
                configuration.initialWorldMap = worldMap
                configuration.planeDetection = [.horizontal, .vertical]
                self.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
                ARSceneSetting.savedARWorldMap = nil
                ARSceneSetting.isRevive = false
                self.viewStore.send(.reset)
            }
            /// 部屋モードではないかつ。selectedModelがnil
            self.focusEntity.isEnabled = ARSceneSetting.selectedModel != nil && ARSceneSetting.sceneMode == .objectPutting
        }.store(in: &self.cancellables)
    }
    
    private func removeObjectNodes(with room: CapturedRoom) {
        room.objects.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            scene.removeAnchor(roomNode.anchorEntity)
        }
        room.doors.forEach {
            let roomDoor = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomDoor, uuid: $0.identifier.uuidString)
            scene.removeAnchor(roomNode.anchorEntity)
        }
        room.openings.forEach {
            let roomOpenings = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomOpenings, uuid: $0.identifier.uuidString)
            scene.removeAnchor(roomNode.anchorEntity)
        }
        room.windows.forEach {
            let roomWindow = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomWindow, uuid: $0.identifier.uuidString)
            scene.removeAnchor(roomNode.anchorEntity)
        }
        room.walls.forEach {
            let roomWall = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomWall, uuid: $0.identifier.uuidString)
            scene.removeAnchor(roomNode.anchorEntity)
        }
    }
    
    private func addObjectNodes(with room: CapturedRoom) {
        room.objects.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            roomNode.updateObject()
            scene.anchors.append(roomNode.anchorEntity)
        }
        room.walls.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            scene.anchors.append(roomNode.anchorEntity)
        }
        room.doors.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            roomNode.updateSurface()
            scene.anchors.append(roomNode.anchorEntity)
        }
        room.openings.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            roomNode.updateSurface()
            scene.anchors.append(roomNode.anchorEntity)
        }
        room.windows.forEach {
            let roomObject = RoomObjectAnchor($0)
            let roomNode = RoomNode(roomObject: roomObject, uuid: $0.identifier.uuidString)
            roomNode.updateSurface()
            scene.anchors.append(roomNode.anchorEntity)
        }
    }
}

extension HomeARView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    }
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        viewStore.send(.showFailedAlert)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        viewStore.send(.sendCollaborationData(data))
    }
}

extension HomeARView: RoomCaptureSessionDelegate {
    
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        print(#function)
        self.addObjectNodes(with: room)
    }
    
    func captureSession(_ session: RoomCaptureSession, didRemove room: CapturedRoom) {
        print(#function)
        self.removeObjectNodes(with: room)
    }
    
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        print(#function)
        if ARSceneSetting.currentAnchorState == .objToRoom {
            self.addObjectNodes(with: room)
            viewStore.send(.completeAddAnchor)
        }
    }
    
    func captureSession(_ session: RoomCaptureSession, didStartWith configuration: RoomCaptureSession.Configuration) {
        print(#function)
        self.session = session.arSession
    }
}

