//
//  File.swift
//  
//
//  Created by ミズキ on 2022/10/23.
//

import SwiftUI
import RealityKit
import ComposableArchitecture
import EntityModule

public struct HomeView : View {
    public let store: StoreOf<HomeFeature>
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom,
                   content: {
                ZStack(alignment: .top,
                       content: {
                        HomeARViewContainer(store: store)
                    HStack(alignment: .bottom,
                           content: {
                        if viewStore.state.isSaveARWorld,
                            ARSceneSetting.savedARWorldMap != nil {
                            ReviveButton(store: store)
                        }
                            CustomSegmentView(store: store)
                                .padding(.top, 70)
                                .frame(width: 300)
                    })
                })
                HomeControlButtonsBarView(store: store)
            })
            .ignoresSafeArea(.all)
            .alert(store.scope(state: { $0.alert }),
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
