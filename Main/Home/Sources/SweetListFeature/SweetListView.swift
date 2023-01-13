//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.

import SwiftUI
import ComposableArchitecture
import SweetDetailFeature
import ViewComponents

public struct SweetListView: View {
    
    private let store: StoreOf<SweetListFeature>
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView(content: {
                HStack(content: {
                    List(content: {
                        ForEach(viewStore.sweets,
                                content: { sweet in
                            NavigationLink(destination: IfLetStore(
                                self.store.scope(state: \.selection?.value,
                                                             action: SweetListFeature.Action.detailAction),
                                            then: { SweetDetailView(store: $0) })
                                           , tag: sweet.id, selection: viewStore.binding(get: \.selection?.id,
                                                                                         send: SweetListFeature.Action.setNavigation(selection:))) {
                                ListCellWithImage(image: Image(systemName: sweet.name),
                                                  title: sweet.name)
                            }
                        })
                    })
                })
                .alert(self.store.scope(state: { $0.alert }),
                       dismiss: .dismissAlert)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading,
                                content: {
                        Button(action: {
                            dismiss()
                        },label: {
                             Image(systemName: "clear.fill")
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
