//
//  CoachingOverlayFeature.swift
//  
//
//  Created by ミズキ on 2022/11/26.
//

import ARKit
import RealityKit

final class CoachingOverlayFeature: NSObject {

    private let session: ARSession
    
    private let overlayView = ARCoachingOverlayView(frame: .zero)
    
    init(session: ARSession) {
        self.session = session
        super.init()
        overlayView.activatesAutomatically = true
        overlayView.session = session
        overlayView.delegate = self
        overlayView.goal = .horizontalPlane
    }
    
    func setupOverlayView(view: ARView) {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        NSLayoutConstraint.activate(
            [
                overlayView.topAnchor.constraint(equalTo: view.topAnchor),
                overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
}
extension CoachingOverlayFeature: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("コーチングが表示される前に呼ばれる")
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("コーチングの非表示が完了したら呼ばれる")
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        print("セッションをリセットしてリローカライズされると呼ばれる。")
    }
}
