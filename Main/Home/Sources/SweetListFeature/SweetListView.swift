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
                List(viewStore.sweets,
                     rowContent: { sweet in
                    NavigationLink(destination: {
                        SweetDetailView(sweet: sweet)
                    }, label: {
                        ListCellWithImage(image: Image(systemName: sweet.name),
                                          title: sweet.name)
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
                .onDisappear(perform: {
                    viewStore.send(.onDisappear)
                })
            })
        }
    }
    
    public init(store: StoreOf<SweetListFeature>) {
        self.store = store
    }
}
