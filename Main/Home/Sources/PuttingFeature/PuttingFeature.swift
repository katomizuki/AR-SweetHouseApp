//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture

public struct PuttingFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var alert: AlertState<Action>?
        public init() { }
    }
    
    public enum Action: Equatable {
        case onAppear
        case showFailedAlert
        case dismissAlert
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            break
        case .showFailedAlert:
            state.alert = .init(title: .init("不明なエラーが発生しました"))
        case .dismissAlert:
            state.alert = nil
        }
        return .none
    }
    
}
