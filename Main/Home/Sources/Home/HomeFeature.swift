//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/23.
//

import ComposableArchitecture

public struct HomeFeature: ReducerProtocol {
    
    public typealias State = HomeState
    public typealias Action = HomeAction
    
    public struct HomeState: Equatable {
        var isSweetListView: Bool = false
        var isSettingView: Bool = false
        var isPuttingView: Bool = false
        
        public init() { }
    }
    
    public enum HomeAction: Equatable {
        case onApear
        case onTapSweetListButton
        case onTapSettingButton
        case onTapPuttiingButton
    }
    
    public struct HomeEnvironment {
        public init() { }
    }
    
    public init() { }
    // Effectを使用する場合はEffect型を返す。
    public func reduce(into state: inout HomeState, action: HomeAction) -> ComposableArchitecture.Effect<HomeAction, Never> {
        switch action {
        case .onApear:
            return .none
        case .onTapSettingButton:
            state.isSettingView.toggle()
            return .none
        case .onTapSweetListButton:
            state.isSettingView.toggle()
        case .onTapPuttiingButton:
            state.isPuttingView.toggle()
            return .none
        }
        return .none
    }
}
