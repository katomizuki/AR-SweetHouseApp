//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/06.
//

import SwiftUI
import RealityKit
import ComposableArchitecture
import EntityModule

public struct CustomSegmentView: View {
    public let store: StoreOf<HomeFeature>
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            Picker(viewStore.state.currentARSceneMode.description,
                   selection: viewStore.binding(get: \.currentARSceneMode,
                                                send: .onTapSegment),
                   content: {
                ForEach(ARSceneMode.allCases,
                        content: { sceneMode in
                    Text(sceneMode.description).tag(sceneMode)
                })
            })
            .colorMultiply(.blue)
            .pickerStyle(.segmented)
        }
    }
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}
