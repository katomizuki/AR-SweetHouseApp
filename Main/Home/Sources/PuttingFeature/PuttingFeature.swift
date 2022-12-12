//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture

public struct PuttingFeature: ReducerProtocol {
    
    public struct State: Equatable {
        
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
        return .none
    }
    
}
