//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/13.
//

import SwiftUI
import ComposableArchitecture

public struct SweetDetailView: View {
    private let store: StoreOf<SweetDetailFeature>
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(content: {
                
            })
            .onAppear(perform: {
                viewStore.send(.onAppear)
            })
        }
    }
    
    public init(store: StoreOf<SweetDetailFeature>) {
        self.store = store
    }
}
