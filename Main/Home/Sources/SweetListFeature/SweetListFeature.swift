//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture
import EntityModule
import SwiftUI
import SweetDetailFeature

let list = [Sweet(name: "a", thumnail: "apple.logo", description: "説明"),
              Sweet(name: "b", thumnail: "apple.logo", description: "説明"),
              Sweet(name: "c", thumnail: "apple.logo", description: "説明")]

public struct SweetListFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var sweets = Sweets(list: list)
        var detailState = SweetDetailFeature.State()
        public init() { }
        public static func == (lhs: SweetListFeature.State, rhs: SweetListFeature.State) -> Bool {
            return true
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case detailAction(SweetDetailFeature.Action)
    }
    
    public init() { }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .none
            case .detailAction:
                return .none
            }
        }
        
        Scope(state: \.detailState, action: /Action.detailAction) {
            SweetDetailFeature()
        }
    }
}

