//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/05.
//

import SwiftUI
import EntityModule

public struct CustomSegmentView: View {
    @State private var selectARSceneMode = ARSceneMode.objectPutting
    public var body: some View {
        Picker(selectARSceneMode.description,
               selection: $selectARSceneMode,
               content: {
            ForEach(ARSceneMode.allCases,
                    content: { sceneMode in
                Text(sceneMode.description).tag(sceneMode)
            })
        })
        .colorMultiply(.blue)
        .pickerStyle(.segmented)
    }
    
    public init() { }
}
