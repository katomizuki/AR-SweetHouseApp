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
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.onTapNavigationTrailingButton)
                    } label: {
                        Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                            .font(.system(size: 16,
                                          weight: .heavy))
                            .foregroundColor(.white)
                            .rotationEffect(.init(degrees: viewStore.state.rotationEffect))
                            .frame(width: 42,
                                   height: 42)
                            .background {
                                RoundedRectangle(cornerRadius: 15,
                                                 style: .continuous)
                                    .fill(.white.opacity(0.2))
                            }
                    }
                }
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
