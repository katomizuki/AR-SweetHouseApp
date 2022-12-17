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

final class HomeARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupSessionDelegate()
        setupConfiguration()
        setupOverlayView()
        setupSubscribeARScene()
    }
    
    private func setupSessionDelegate() {
        session.delegate = self
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
        let cancellable = scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
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
