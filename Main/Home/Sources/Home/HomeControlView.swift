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

struct HomeControlButtonsBarView: View {
    let store: Store<HomeFeature.HomeState, HomeFeature.HomeAction>
    var body: some View {
        HStack(alignment: .center,
               content: {
            HomeControlsButtons(store: store)
        })
    }
}

struct HomeControlsButtons: View {
    let store: Store<HomeFeature.HomeState, HomeFeature.HomeAction>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(self.store,
                      content: { viewStore in
            HStack(content: {
                ControlButton(systemName: "square.grid.2x2", action: {
                    viewStore.send(.onTapSettingButton)
                })
                .sheet(isPresented: viewStore.binding(get: \.isSettingView,
                                                      send: .onTapSettingButton),
                       content: {
                    SettingFeature.SettiingView()
                })
                
                Spacer()
                
                ControlButton(systemName: "square.grid.2x2", action: {
                    viewStore.send(.onTapSweetListButton)
                })
                .sheet(isPresented: viewStore.binding(get: \.isSweetListView,
                                                      send: .onTapSweetListButton),
                       content: {
                    SweetListFeature.SweetListView()
                })
                
                Spacer()
                
                ControlButton(systemName: "square.grid.2x2", action: {
                    viewStore.send(.onTapPuttiingButton)
                })
                .sheet(isPresented: viewStore.binding(get: \.isPuttingView,
                                                      send: .onTapPuttiingButton),
                       content: {
                    PuttingFeature.PuttingView()
                })
            })
            .frame(maxWidth: 500)
            .padding(30)
            .background(.black.opacity(0.25))
        })
    }
}
