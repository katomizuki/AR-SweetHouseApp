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
    public let store: StoreOf<HomeFeature>
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom,
                   content: {
                ZStack(alignment: .top,
                       content: {
                        HomeARViewContainer(store: store)
                        CustomSegmentView(store: self.store)
                            .padding(.top, 70)
                            .frame(width: 300)
                })
                HomeControlButtonsBarView(store: store)
            })
            .ignoresSafeArea(.all)
            .alert(self.store.scope(state: { $0.alert }),
                   dismiss: .alertDismiss)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}
