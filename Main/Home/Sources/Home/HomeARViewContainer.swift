//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import RealityKit
import CoachingOverlayFeature

struct HomeARViewContainer: UIViewRepresentable {
  typealias UIViewType = HomeARView
    
    func updateUIView(_ uiView: HomeARView, context: Context) {
    }
    
    func makeUIView(context: Context) -> HomeARView {
        let arView = HomeARView(frame: .zero)
        return arView
    }
}
