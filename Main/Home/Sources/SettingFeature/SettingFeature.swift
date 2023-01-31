//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture
import EntityModule

public struct SettingFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var alert: AlertState<Action>?
        var isAllowHaptics: Bool = UserSetting.isAllowHaptics
        public init() { }
    }
    
    public enum Action: Equatable {
        case onAppear
        case showFailedAlert
        case dismissAlert
        case toggleHaptics
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            break
        case .toggleHaptics:
            state.isAllowHaptics.toggle()
            UserSetting.isAllowHaptics = state.isAllowHaptics
        case .dismissAlert:
            state.alert = nil
        case .showFailedAlert:
            state.alert = .init(title: .init("Unknown error occurred."))
        }
        return .none
    }
}

