//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture
import EntityModule
import SwiftUI

let list = [Sweet(name: "a", thumnail: Image(systemName: "apple.logo"), description: "説明"),
              Sweet(name: "b", thumnail: Image(systemName: "apple.logo"), description: "説明"),
              Sweet(name: "c", thumnail: Image(systemName: "apple.logo"), description: "説明")]

public struct SweetListFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var sweets = Sweets(list: list)
        public init() { }
    }
    
    public enum Action: Equatable {
        case onAppear
    }
    
    public init() { }
   
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            return .none
        }
    }
    
}

