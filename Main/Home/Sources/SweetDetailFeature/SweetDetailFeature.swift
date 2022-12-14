//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/13.
//

import ComposableArchitecture
import EntityModule

public struct SweetDetailFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var sweet: Sweet!

        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case onAppear
    }
    
    public struct Environment {
        public init() { }
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            return .none
        }
    }
    
}
