//
//  File.swift
//  
//
//  Created by ミズキ on 2022/10/23.
//

import SwiftUI
import RealityKit
import ComposableArchitecture
import MultiPeerFeature

public struct ContentView : View {
    public var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
    public init() { }
}

 struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
