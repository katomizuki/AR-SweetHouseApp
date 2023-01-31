//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/31.
//

import SwiftUI
import ComposableArchitecture

struct ReviveButton: View {
    
    private let store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(store,
                      observe: { $0 },
                      content: { viewStore in
            Button(action: {
                viewStore.send(.onTapReviveButton)
            }, label: {
                Text("Revive AR World!")
                    .font(.caption2)
                    .foregroundColor(.orange)
            })
        })
    }
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}
