//
//  File.swift
//  
//
//  Created by ミズキ on 2022/10/23.
//

import SwiftUI
import RealityKit
import ComposableArchitecture

public struct HomeView : View {
    public var body: some View {
        ZStack(alignment: .bottom,
               content: {
            HomeARViewContainer()
            HomeControlButtonsBarView()
        })
        .ignoresSafeArea(.all)
    }
    public init() { }
}
