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

struct CustomARScnViewContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomARScnViewController
    private let store: StoreOf<HomeFeature>

    func updateUIViewController(_ uiViewController: CustomARScnViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> CustomARScnViewController {
        let store = self.store.scope(state: \.arScnState,
                                     action: HomeFeature.Action.arScn)
        let vc = CustomARScnViewController(store: store)
        return vc
    }
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}
