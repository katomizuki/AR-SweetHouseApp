//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import RealityKit
import ComposableArchitecture

struct HomeARViewContainer: UIViewRepresentable {
  typealias UIViewType = HomeARView
    private let store: StoreOf<HomeFeature>
    
    func updateUIView(_ uiView: HomeARView, context: Context) {
    }
    
    func makeUIView(context: Context) -> HomeARView {
        let store = self.store.scope(state: \.arViewState,
                                     action: HomeFeature.Action.arView)
        let arView = HomeARView(store: store)
        return arView
    }

    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}
