//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/23.
//

import ComposableArchitecture
import SweetListFeature
import SettingFeature
import WorldMapFeature
import ARKit
import SwiftUI
import HapticsFeature
import RoomPlan
import EntityModule
import RealityKit
import MultiPeerFeature
import MultipeerConnectivity

public struct HomeFeature: ReducerProtocol {
    private static var arSession: ARSession?
    private static var roomSession: RoomCaptureSession?
    private var multipeerSession: MultipeerSession!
    
    
    public struct State: Equatable {
        var canUseApp: Bool = false
        var tabState: TabState = TabState()
        var currentARSceneMode: ARSceneMode = .objectPutting
        var sweetListState = SweetListFeature.State()
        var settingState = SettingFeature.State()
        var arViewState = ARFeature.State()
        var alert: AlertState<Action>?
        var collaborationData: ARSession.CollaborationData?
        public init() { }
    }
    
    public enum Action: Equatable {
        case onAppear
        case toggleSweetListView
        case toggleSettingView
        case sweetList(SweetListFeature.Action)
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
        case onTapMultipeer
    }

    public init() {
        self.multipeerSession = MultipeerSession(receiveDataHandler: self.recevieData(_:from:),
                                                 peerJoinedHandler: self.peerJoinedHandler(_:),
                                                 peerLeftHandler: self.peerLeftHandler(_:),
                                                 peerDiscoverdHandler: self.peerDiscoverdHandler(_:))
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
                state.tabState.isSettingView.toggle()
            case .toggleSweetListView:
                state.tabState.isSweetListView.toggle()
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
                if hapticsFeature.supportedHaptics(), UserSetting.isAllowHaptics {
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
                if hapticsFeature.supportedHaptics(), UserSetting.isAllowHaptics {
                    hapticsFeature.eventHaptics()
                }
            case .onTapSegment:
                if state.currentARSceneMode == .objectPutting {
                    state.currentARSceneMode = .roomPlan
                    UserSetting.sceneMode = .roomPlan
                } else {
                    state.currentARSceneMode = .objectPutting
                    UserSetting.sceneMode = .objectPutting
                }
            case .sweetList(let action):
                if action == .dismissAll {
                    state.tabState.isSweetListView.toggle()
                }
                return .none
            case .onTapMultipeer:
                // ボタンなどはつけずにやったほうがええかも
                if let data = state.collaborationData,
                   let collaborationData = try? NSKeyedArchiver.archivedData(withRootObject: data,
                                                                             requiringSecureCoding: true) {
                    multipeerSession.sendToAllPeers(collaborationData,
                                                    reliably: true)
                }
               // 通信
                return .none
            case .setting(let settingFeatureAction):
                return .none
            case .arView(let arFeatureAction):
                switch arFeatureAction {
                case .sendARSession(let session, let roomSession):
                    Self.arSession = session
                    Self.roomSession = roomSession
                case .syncCollaborationData(let collaborationData):
                    state.collaborationData = collaborationData
                default: break
                }
                return .none
            }
            return .none
        }


        Scope(state: \.sweetListState, action: /Action.sweetList) {
            SweetListFeature()
        }
        
        Scope(state: \.settingState, action: /Action.setting) {
            SettingFeature()
        }
        
        Scope(state: \.arViewState, action: /Action.arView) {
            ARFeature()
        }
    }
    
    func recevieData(_ data: Data, from peer: MCPeerID) {
        // 受け取ったデータをCollaborationDataに変換する。
        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self,
                                                                           from: data) {
            Self.arSession?.update(with: collaborationData)
        }
    }
    
    func peerJoinedHandler(_ peerId: MCPeerID) {
        UserSetting.connectText = "端末と繋がりました"
    }
    
    func peerLeftHandler(_ peerId: MCPeerID) {
        UserSetting.connectText = "端末との接続が切れました。"
    }
    
    func peerDiscoverdHandler(_ peerId: MCPeerID) -> Bool {
        UserSetting.connectText = "端末を発見しました"
        return true
    }
}
