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
                                ListCellWithImage(image: Image(systemName: sweet.thumbnail),
                                                  title: sweet.name)
                            })
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
