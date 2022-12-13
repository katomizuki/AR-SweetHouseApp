//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/23.
//

import ComposableArchitecture
import SweetListFeature
import PuttingFeature
import SettingFeature

public struct HomeFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var isSweetListView: Bool = false
        var isSettingView: Bool = false
        var isPuttingView: Bool = false
        var sweetListState = SweetListFeature.State()
        var puttingState = PuttingFeature.State()
        var settingState = SettingFeature.State()
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case onAppear
        case onTapSweetListButton
        case onTapSettingButton
        case onTapPuttiingButton
        case sweetList(SweetListFeature.Action)
        case putting(PuttingFeature.Action)
        case setting(SettingFeature.Action)
    }
    
    public init() { }
    
    @Dependency(\.mainQueue) var mainQueue
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
            case .onTapSettingButton:
                state.isSettingView.toggle()
            case .onTapSweetListButton:
                state.isSweetListView.toggle()
            case .onTapPuttiingButton:
                state.isPuttingView.toggle()
            default: return .none
            }
            return .none
        }
        
        Scope(state: \.sweetListState, action: /Action.sweetList) {
            SweetListFeature()
        }
        
        Scope(state: \.puttingState, action: /Action.putting) {
            PuttingFeature()
        }
        
        Scope(state: \.settingState, action: /Action.setting) {
            SettingFeature()
        }
    }
}
