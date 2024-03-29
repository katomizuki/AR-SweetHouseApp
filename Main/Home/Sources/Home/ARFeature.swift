//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/22.
//

import ComposableArchitecture
import RealityKit
import ARKit
import RoomPlan
import EntityModule

public struct ARFeature: ReducerProtocol {
    
    public enum Action: Equatable {
        case subscriveEvent(session: ARSession?, roomSession: RoomCaptureSession?)
        case onTouchARView
        case initialize
        case showFailedAlert
        case dismissAlert
        case completeAddAnchor
        case disAppear
        case sendARSession(arSession: ARSession?,
                           roomSession: RoomCaptureSession?)
        case sendCollaborationData(_ collaborationData: ARSession.CollaborationData)
        case syncCollaborationData(_ collaborationData: ARSession.CollaborationData)
        case reset
        public static func == (lhs: ARFeature.Action, rhs: ARFeature.Action) -> Bool {
            return true
        }
    }
    

    public struct State: Equatable {
        var selectedModel: Entity? = ARSceneSetting.selectedModel
        var arSession: ARSession?
        var roomSession: RoomCaptureSession?
        var alert: AlertState<Action>?
        var addAnchorState = ARSceneSetting.currentAnchorState
        var savedARWorld: ARWorldMap?
        var isReviveARWorld: Bool = false
        
        public static func == (lhs: ARFeature.State, rhs: ARFeature.State) -> Bool {
            return true
        }
    }
    
   public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onTouchARView:
            ARSceneSetting.selectedModel = nil
        case .subscriveEvent(let arSession, let roomSession):
            state.arSession = arSession
            state.roomSession = roomSession
            if ARSceneSetting.sceneMode == .roomPlan,
                state.addAnchorState != .finishAddAnchor {
                ARSceneSetting.currentAnchorState = .objToRoom
            }
            return .task {
                return .sendARSession(arSession: arSession, roomSession: roomSession)
            }
        case .initialize:
            break
        case .showFailedAlert:
            state.alert = .init(title: .init("Unknown error occurred."))
        case .dismissAlert:
            state.alert = nil
        case .completeAddAnchor:
            state.addAnchorState = .finishAddAnchor
            ARSceneSetting.currentAnchorState = .finishAddAnchor
        case .disAppear:
            ARSceneSetting.currentAnchorState = .normal
        case .sendARSession(_,_):
            return .none
        case .sendCollaborationData(let collaborationData):
            return .task {
                return .syncCollaborationData(collaborationData)
            }
        case .syncCollaborationData(_):
            return .none
        case .reset:
            return .none
        }
        return .none
    }
}
