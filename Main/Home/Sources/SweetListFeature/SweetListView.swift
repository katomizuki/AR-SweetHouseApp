//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.

import SwiftUI
import ComposableArchitecture
import SweetDetailFeature

public struct SweetListView: View {
    
    private let store: StoreOf<SweetListFeature>
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView(content: {
                HStack(content: {
                    List(content: {
                        ForEach(viewStore.sweets.list,
                                content: { sweet in
                            NavigationLink(destination: {
                                SweetDetailView(store: self.store.scope(state: \.detailState,
                                                                        action: SweetListFeature.Action.detailAction))
                            }, label: {
                                Text(sweet.name)
                            })
                        })
                    })
                })
            .onAppear(perform: {
                viewStore.send(.onAppear)
            })
        })
    }
}
    
    public init(store: StoreOf<SweetListFeature>) {
        self.store = store
    }
}
