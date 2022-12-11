//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import ViewComponents
import ComposableArchitecture
import SweetListFeature
import SettingFeature
import PuttingFeature

public struct HomeControlButtonsBarView: View {
    public let store: StoreOf<HomeFeature>
    public var body: some View {
        HStack(alignment: .center,
               content: {
            HomeControlsButtons(store: store)
        })
    }
}

public struct HomeControlsButtons: View {
    public let store: StoreOf<HomeFeature>
    
    public var body: some View {
        WithViewStore(self.store,
                      content: { viewStore in
            HStack(content: {
                ControlButton(systemName: "square.grid.2x2", action: {
                    viewStore.send(.onTapSettingButton)
                })
                .sheet(isPresented: viewStore.binding(get: \.isSettingView,
                                                      send: .onTapSettingButton),
                       content: {
                    let store = self.store.scope(state: \.settingState,
                                                 action: HomeFeature.Action.setting)
                    SettiingView(store: store)
                })
                
                Spacer()
                
                ControlButton(systemName: "square.grid.2x2", action: {
                    viewStore.send(.onTapSweetListButton)
                })
                .sheet(isPresented: viewStore.binding(get: \.isSweetListView,
                                                      send: .onTapSweetListButton),
                       content: {
                    let store = self.store.scope(state: \.sweetListState, action: HomeFeature.Action.sweetList)
                    SweetListView(store: store)
                })
                
                Spacer()
                
                ControlButton(systemName: "square.grid.2x2", action: {
                    viewStore.send(.onTapPuttiingButton)
                })
                .sheet(isPresented: viewStore.binding(get: \.isPuttingView,
                                                      send: .onTapPuttiingButton),
                       content: {
                    let store = self.store.scope(state: \.puttingState,
                                                 action: HomeFeature.Action.putting)
                    PuttingView(store: store)
                })
            })
            .frame(maxWidth: 500)
            .padding(30)
            .background(.black.opacity(0.25))
        })
    }

}
