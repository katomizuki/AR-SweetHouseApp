//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import ComposableArchitecture

public struct SettiingView: View {
    private let store: StoreOf<SettingFeature>
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView(content: {
                VStack(content: {
                    List(content: {
                        Toggle(isOn: viewStore.binding(get: \.isAllowHaptics,
                                                       send: .toggleHaptics),
                               label: {
                            Text("Allow to vibrate")
                        })
                        .tint(.orange)
                    })
                })
                .alert(self.store.scope(state: { $0.alert }),
                       dismiss: .dismissAlert)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading,
                                content: {
                        Text("Setting")
                            .foregroundColor(.orange)
                            .font(.title2)
                            .bold()
                    })
                })
                .onAppear(perform: {
                    viewStore.send(.onAppear)
                })
                .onDisappear(perform: {
                    dismiss()
                })
            })
        }
    }
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
}
