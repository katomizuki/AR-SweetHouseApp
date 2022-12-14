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
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(content: {
            })
            .onAppear(perform: {
                viewStore.send(.onAppear)
            })
        }
    }
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
}
