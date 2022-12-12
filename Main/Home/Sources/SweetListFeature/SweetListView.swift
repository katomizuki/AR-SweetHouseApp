//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import ComposableArchitecture

public struct SweetListView: View {
    
    public let store: StoreOf<SweetListFeature>
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(content: {
                List(viewStore.sweets.list) { sweet in
                    Text(sweet.name)
                }
            })
            .onAppear(perform: {
                viewStore.send(.onAppear)
            })
        }
    }
    
    public init(store: StoreOf<SweetListFeature>) {
        self.store = store
    }
}
