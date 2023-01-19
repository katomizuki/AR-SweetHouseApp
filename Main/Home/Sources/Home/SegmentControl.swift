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
            HStack(content: {
                Button(action: {
                    viewStore.send(.onTapMultipeer)
                }, label: {
                    VStack(content: {
                        Image(systemName: "iphone.homebutton.radiowaves.left.and.right.circle.fill")
                            .frame(width: 50,
                                   height: 50)
                        Text("multipeer")
                    })
                })
                Picker(viewStore.state.currentARSceneMode.description,
                       selection: viewStore.binding(get: \.currentARSceneMode,
                                                    send: .onTapSegment),
                       content: {
                    ForEach(ARSceneMode.allCases,
                            content: { sceneMode in
                        Text(sceneMode.description)
                            .tag(sceneMode)
                    })
                })
                .colorMultiply(.blue)
                .pickerStyle(.segmented)
            })
        }
    }
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}
