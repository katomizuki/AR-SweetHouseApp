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
import HapticsFeature
import RoomPlan
import EntityModule

public struct HomeFeature: ReducerProtocol {
    private static var arSession: ARSession?
    
    public struct State: Equatable {
        var isSweetListView: Bool = false
        var isSettingView: Bool = false
        var isPuttingView: Bool = false
        var canUseApp: Bool = false
        var currentARSceneMode: ARSceneMode = .objectPutting
        var sweetListState = SweetListFeature.State()
        var puttingState = PuttingFeature.State()
        var settingState = SettingFeature.State()
        var arViewState: ARFeature.State {
            get {
                ARFeature.State()
            } set {
                HomeFeature.arSession = newValue.arSession
            }
        }
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
        case arView(ARFeature.Action)
        case writeARWorldMap(_ worldMap: ARWorldMap)
        case onTapSaveWorldMapButton
        case showCompleteAlert
        case showFailAlert
        case alertDismiss
        case showDontUseAppAlert
        case toggleCanUseApp
        case completedConnectOtherApp
        case onTapSegment
    }
    
    public init() {
    }
    
   @Dependency(\.mainQueue) var mainQueue
   @Dependency(\.worldMap) var worldMapFeature
   @Dependency(\.hapticsFeature) var hapticsFeature
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
                return .task {
                        if !RoomCaptureSession.isSupported && ARConfiguration.supportsFrameSemantics([.sceneDepth,.smoothedSceneDepth]) {
                            return .showDontUseAppAlert
                        }
                    return .toggleCanUseApp
                }
            case .toggleSettingView:
                state.isSettingView.toggle()
            case .toggleSweetListView:
                state.isSweetListView.toggle()
            case .togglePuttiingView:
                state.isPuttingView.toggle()
            case .onTapSaveWorldMapButton:
                return .task {
                    do {
                        guard  let session = Self.arSession else { return .showFailAlert }
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
            #if targetEnvironment(simulator)
            #else
                if hapticsFeature.supportedHaptics() {
                    hapticsFeature.eventHaptics()
                }
            #endif
                state.alert = .init(title: .init("AR世界の保存に成功しました"))
            case .showFailAlert:
                state.alert = .init(title: .init("AR世界の保存に失敗しました"))
            case .alertDismiss:
                state.alert = nil
            case .showDontUseAppAlert:
                state.alert = .init(title: .init("iOS16以上かつLidarを搭載しているIPhone出ないとこのアプリは使用できません"))
            case .toggleCanUseApp:
                state.canUseApp.toggle()
            case .completedConnectOtherApp:
                if hapticsFeature.supportedHaptics() {
                    hapticsFeature.eventHaptics()
                }
            case .onTapSegment:
                if state.currentARSceneMode == .objectPutting {
                    state.currentARSceneMode = .roomPlan
                } else {
                    state.currentARSceneMode = .objectPutting
                }
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
        
        Scope(state: \.arViewState, action: /Action.arView) {
            ARFeature()
        }
    }
}
