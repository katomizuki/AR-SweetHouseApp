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
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView(content: {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.detailStates,
                            action: SweetListFeature.Action.detailAction(id:action:))) {
                                detailStore in
                                NavigationLink(destination: {
                                    SweetDetailView(detailStore)
                                }, label: {
                                    WithViewStore(detailStore) { detailViewstore in
                                            Text(detailViewstore.state.sweet.name)
                                            .font(.title2)
                                    }
                            })
                      }
                  }
                .alert(self.store.scope(state: { $0.alert }),
                       dismiss: .dismissAlert)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading,
                                content: {
                        Button(action: {
                            dismiss()
                        },label: {
                                Image(systemName: "clear.fill")
                                .foregroundColor(.orange)
                           })
                       })
                   })
                })
                .onAppear(perform: {
                    viewStore.send(.onAppear)
                })
                .onDisappear(perform: {
                    viewStore.send(.onDisappear)
                })
        }
    }
    
    public init(store: StoreOf<SweetListFeature>) {
        self.store = store
    }
}
