//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import ComposableArchitecture

public struct PuttingView: View {
    public let store: StoreOf<PuttingFeature>
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(content: {
                
            })
            .background(.blue)
        }
    }
    
    public init(store: StoreOf<PuttingFeature>) {
        self.store = store
    }
}
