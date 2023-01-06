//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/06.
//

import ComposableArchitecture

public struct ARScnFeature: ReducerProtocol {
    public enum Action: Equatable {
        case showFailedAlert
        case dismissAlert
    }
    
    public struct State: Equatable {
        var alert: AlertState<Action>?
    }
    
   public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .showFailedAlert:
            state.alert = .init(title: .init("不明なエラーが発生しました"))
        case .dismissAlert:
            state.alert = nil
        }
        return .none
    }
}
