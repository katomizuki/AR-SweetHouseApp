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
import ARSceneManager
import RoomPlan
import FocusEntity

final class HomeARView: ARView {

    private var cancellable: Cancellable?
    
    private lazy var caputureSession: RoomCaptureSession = {
        let captureSession = RoomCaptureSession()
        session = captureSession.arSession
        return captureSession
    }()
    private let roomBuilder = RoomBuilder(options: [.beautifyObjects])
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupSessionDelegate()
        setupConfiguration()
        setupOverlayView()
        setupSubscribeARScene()
        setupRoomCaptureDelegate()
        
    }
    
    private func setupSessionDelegate() {
        session.delegate = self
    }
    
    private func setupRoomCaptureDelegate() {
//        caputureSession.delegate = self
    }
    
    private func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration)
    }
    
    private func setupOverlayView() {
        let overlayFeature = CoachingOverlayFeature(session: session)
        overlayFeature.setupOverlayView(view: self)
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubscribeARScene() {
        self.cancellable = scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
            ARSceneClient.session = self?.session
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
extension HomeARView: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didAdd room: CapturedRoom) {
        
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
        
    }
    
    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        Task {
            do {
                let finalRoom = try await roomBuilder.capturedRoom(from: data)
            } catch {
              print(error)
            }
        }
    }
}
