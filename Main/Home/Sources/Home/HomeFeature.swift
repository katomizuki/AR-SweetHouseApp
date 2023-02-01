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
import UtilFeature

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
        var isSaveARWorld = false
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
        case onTapReviveButton
        case sendARWorldMap(worldMap: ARWorldMap)
    }

    public init() {
        self.multipeerSession = MultiPeerFeature.MultipeerSession(receiveDataHandler: self.recevieData(_:from:),
                                                 peerJoinedHandler: self.peerJoinedHandler(_:),
                                                 peerLeftHandler: self.peerLeftHandler(_:),
                                                 peerDiscoverdHandler: self.peerDiscoverdHandler(_:))
    }
    
   @Dependency(\.mainQueue) var mainQueue
   @Dependency(\.worldMap) var worldMapFeature
   @Dependency(\.hapticsFeature) var hapticsFeature
   @Dependency(\.userDefaultsManager) var userDefalutsManager
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
                state.isSaveARWorld = userDefalutsManager.loadARWorldFlag()
                do {
                    // willAppearの時にARWorldmapがロードしている
                    ARSceneSetting.savedARWorldMap = try worldMapFeature.loadWorldMap()
                } catch {
                    print(error.localizedDescription)
                }
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
                        ARSceneSetting.savedARWorldMap = worldMap
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
                if hapticsFeature.supportedHaptics(),
                    ARSceneSetting.isAllowHaptics {
                    hapticsFeature.eventHaptics()
                }
            #endif
                state.alert = .init(title: .init("AR world successfully saved!"))
                state.isSaveARWorld = true
                userDefalutsManager.saveARWorldFlag(flag: true)
            case .showFailAlert:
                state.alert = .init(title: .init("Failed to save AR world"))
                state.isSaveARWorld = false
                userDefalutsManager.saveARWorldFlag(flag: false)
            case .alertDismiss:
                state.alert = nil
            case .showDontUseAppAlert:
                state.alert = .init(title: .init("This application can only be used on IPhone with iOS16 or higher and Lidar."))
            case .toggleCanUseApp:
                state.canUseApp.toggle()
            case .onTapReviveButton:
                return .task {
                    do {
                        let worldMap = try worldMapFeature.loadWorldMap()
                        return .sendARWorldMap(worldMap: worldMap)
                    } catch {
                        return .showFailAlert
                    }
                }
            case .completedConnectOtherApp:
                if hapticsFeature.supportedHaptics(),
                   ARSceneSetting.isAllowHaptics {
                    hapticsFeature.eventHaptics()
                }
            case .sendARWorldMap(_):
                ARSceneSetting.isRevive = true
                return .none
            case .onTapSegment:
                if state.currentARSceneMode == .objectPutting {
                    state.currentARSceneMode = .roomPlan
                    ARSceneSetting.sceneMode = .roomPlan
                } else {
                    state.currentARSceneMode = .objectPutting
                    ARSceneSetting.sceneMode = .objectPutting
                }
            case .sweetList(let action):
                if action == .dismissAll {
                    state.tabState.isSweetListView.toggle()
                }
                return .none
            case .onTapMultipeer:
            #if targetEnvironment(simulator)
            #else
                if let data = state.collaborationData,
                   let collaborationData = try? NSKeyedArchiver.archivedData(withRootObject: data,
                                                                             requiringSecureCoding: true) {
                    multipeerSession.sendToAllPeers(collaborationData,
                                                    reliably: true)
                }
            #endif
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
        ARSceneSetting.connectText = "端末と繋がりました"
    }
    
    func peerLeftHandler(_ peerId: MCPeerID) {
        ARSceneSetting.connectText = "端末との接続が切れました。"
    }
    
    func peerDiscoverdHandler(_ peerId: MCPeerID) -> Bool {
        ARSceneSetting.connectText = "端末を発見しました"
        return true
    }
}
