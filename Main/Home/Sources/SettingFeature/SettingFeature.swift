//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture

public struct SettingFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var alert: AlertState<Action>?
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case showFailedAlert
        case dismissAlert
    }
    
    public struct SettingEnvironment {
        public init() { }
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            break
        case .dismissAlert:
            state.alert = nil
        case .showFailedAlert:
            state.alert = .init(title: .init("不明なエラーが発生しました"))
        }
        return .none
    }
}

