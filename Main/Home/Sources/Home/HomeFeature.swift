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
import WorldMapFeature
import ARKit
import SwiftUI
import ARSceneManager
import HapticsFeature

public struct HomeFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var isSweetListView: Bool = false
        var isSettingView: Bool = false
        var isPuttingView: Bool = false
        var sweetListState = SweetListFeature.State()
        var puttingState = PuttingFeature.State()
        var settingState = SettingFeature.State()
        var alert: AlertState<Action>?
        public init() { }
    }
    
    public enum Action: Equatable {
        case onAppear
        case toggleSweetListView
        case toggleSettingView
        case togglePuttiingView
        case sweetList(SweetListFeature.Action)
        case putting(PuttingFeature.Action)
        case setting(SettingFeature.Action)
        case writeARWorldMap(_ worldMap: ARWorldMap)
        case onTapSaveWorldMapButton
        case showCompleteAlert
        case showFailAlert
        case alertDismiss
    }
    
    public init() {
    }
    
   @Dependency(\.mainQueue) var mainQueue
   @Dependency(\.worldMap) var worldMapFeature
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
            case .toggleSettingView:
                state.isSettingView.toggle()
            case .toggleSweetListView:
                state.isSweetListView.toggle()
            case .togglePuttiingView:
                state.isPuttingView.toggle()
            case .onTapSaveWorldMapButton:
                return .task {
                    do {
                        guard let session =  ARSceneClient.session else { return .showFailAlert }
                        let worldMap = try await worldMapFeature.getCurrentWorldMap(session)
                        return .writeARWorldMap(worldMap)
                    } catch {
                        return .showFailAlert
                    }
                }
            case .writeARWorldMap(let worldMap):
                return .task {
                    do {
                        try worldMapFeature.writeWorldMap(worldMap)
                        return .showCompleteAlert
                    } catch {
                        return .showFailAlert
                    }
                }
            case .showCompleteAlert:
                state.alert = .init(title: .init("Completed"))
            case .showFailAlert:
                state.alert = .init(title: .init("Failed"))
            case .alertDismiss:
                state.alert = nil
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
