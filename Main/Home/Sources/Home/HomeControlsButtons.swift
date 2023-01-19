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

public struct HomeControlsButtons: View {
    public let store: StoreOf<HomeFeature>
    
    public var body: some View {
        WithViewStore(self.store,
                      content: { viewStore in
            HStack(content: {
                ControlButton(systemName: "square.grid.2x2",
                              buttonTitle: "settings",
                              action: {
                    viewStore.send(.toggleSettingView)
                })
                .sheet(isPresented: viewStore.binding(get: \.tabState.isSettingView,
                                                      send: .toggleSettingView),
                       onDismiss: {
                    viewStore.send(.toggleSettingView)
                } ,
                       content: {
                    let store = self.store.scope(state: \.settingState,
                                                 action: HomeFeature.Action.setting)
                    SettiingView(store: store)
                })
                
                Spacer()
                
                ControlButton(systemName: "list.bullet",
                              buttonTitle: "sweet list",
                              action: {
                    viewStore.send(.toggleSweetListView)
                })
                .fullScreenCover(isPresented: viewStore.binding(get: \.tabState.isSweetListView,
                                                      send: .toggleSweetListView),
                                 onDismiss: {
                    viewStore.send(.toggleSweetListView)
                },
                                 content: {
                    let store = self.store.scope(state: \.sweetListState,
                                                 action: HomeFeature.Action.sweetList)
                    SweetListView(store: store)
                })
            
                Spacer()
                
                ControlButton(systemName: "arkit",
                              buttonTitle: "save the AR World Map",
                              action: {
                    viewStore.send(.onTapSaveWorldMapButton)
                })
                
            })
            .frame(maxWidth: 500)
            .padding(30)
            .background(.black.opacity(0.25))
        })
    }

}
