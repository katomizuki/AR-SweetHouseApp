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

final class HomeARView: ARView {
    
    private var cancellable: Cancellable?
    private let viewStore: ViewStoreOf<ARFeature>
    var focusEntity: FocusEntity?
    private let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    
    required init(store: StoreOf<ARFeature>) {
        self.viewStore = ViewStore(store)
        super.init(frame: .zero)
        viewStore.send(.initialize)
        setupSessionDelegate()
        setupConfiguration()
        setupOverlayView()
        setupSubscribeARScene()
        setupFocusEntity()
        setupTouchUpEvent()
    }
    
    private func setupSessionDelegate() {
        session.delegate = self
    }
    
    private func setupFocusEntity() {
        self.focusEntity = FocusEntity(on: self,style: .classic(color: .orange))
        self.focusEntity?.delegate = self
    }
    
    private func setupTouchUpEvent() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(onTouchARView))
        self.addGestureRecognizer(touchGesture)
    }
    
    @objc private func onTouchARView(_ sender: UITapGestureRecognizer) {
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
        guard let selectedModel = viewStore.state.selectedModel else { return }
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(selectedModel)
        scene.anchors.append(anchorEntity)
    }
    
    private func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) && ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.sceneReconstruction = [.meshWithClassification]
            configuration.planeDetection = [.horizontal, .vertical]
        }
        session.run(configuration)
    }
    
    private func setupOverlayView() {
        let overlayFeature = CoachingOverlayFeature(session: session)
        overlayFeature.setupOverlayView(view: self)
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func setupSubscribeARScene() {
        self.cancellable = scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
            self?.viewStore.send(.subscriveEvent(session: self?.session))
        }
    }
    
    
    
}

extension HomeARView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        
    }
    
    private func makeMesh(normals: [SIMD3<Float>],
                          positions: [SIMD3<Float>],
                          indices:[UInt32]) -> ModelEntity? {
        var descriptor = MeshDescriptor(name: "mesh")
        descriptor.positions = MeshBuffer(positions)
        descriptor.normals = MeshBuffer(normals)
        descriptor.primitives = .triangles(indices)
        let material: Material = SimpleMaterial(color: .red, isMetallic: false)
        do {
            let mesh = try MeshResource.generate(from: [descriptor])
            return ModelEntity(mesh: mesh, materials: [material])
        } catch {
            return nil
        }
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
    
    func session(_ session: ARSession, didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer) {
        
    }
    
    func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
        
    }
    
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        
    }
}

extension HomeARView: FocusEntityDelegate {
    func toTrackingState() {
        
    }
    
    func toInitializingState() {
        
    }
    
    private func focusEntity(_ focusEntity: FocusEntity.State, trackingUpdated trackingState: FocusEntity.State, oldState: FocusEntity.State) {
        
    }
    
    func focusEntity(_ focusEntity: FocusEntity, planeChanged: ARPlaneAnchor?, oldPlane: ARPlaneAnchor?) {
        
    }
}

extension ARMeshGeometry {
    func classificationOf(index: Int) -> ARMeshClassification {
        guard let classification = classification else  { return .none }
        let classificationPointer = classification.buffer.contents().advanced(by: classification.offset + (classification.stride * index))
        let classificationValue = Int(classificationPointer.assumingMemoryBound(to: CUnsignedChar.self).pointee)
        return ARMeshClassification(rawValue: classificationValue) ?? .none
    }
}
