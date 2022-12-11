//
//  File.swift
//  
//
//  Created by ミズキ on 2022/10/23.
//

import SwiftUI
import RealityKit
import ComposableArchitecture

public struct HomeView : View {
    public let store: Store<HomeFeature.HomeState, HomeFeature.HomeAction>
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .bottom,
                   content: {
                HomeARViewContainer()
                HomeControlButtonsBarView(store: store)
            })
            .ignoresSafeArea(.all)
            .onAppear {
                viewStore.send(.onApear)
            }
        }
    }

    public init(store: Store<HomeFeature.HomeState, HomeFeature.HomeAction>) {
        self.store = store
    }
}
