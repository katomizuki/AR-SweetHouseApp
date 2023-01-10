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
        public static func == (lhs: ARFeature.Action, rhs: ARFeature.Action) -> Bool {
            return true
        }
    }
    

    public struct State: Equatable {
        var isSelectedModel = false
        var selectedModel: Entity? = UserSetting.selectedModel
        var arSession: ARSession?
        var roomSession: RoomCaptureSession?
        var alert: AlertState<Action>?
        var addAnchorState = UserSetting.currentAnchorState
        
        public static func == (lhs: ARFeature.State, rhs: ARFeature.State) -> Bool {
            return true
        }
    }
    
   public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onTouchARView:
            state.isSelectedModel = false
        case .subscriveEvent(let arSession, let roomSession):
            state.arSession = arSession
            state.roomSession = roomSession
            if UserSetting.sceneMode == .roomPlan,
                state.addAnchorState != .finishAddAnchor {
                UserSetting.currentAnchorState = .objToRoom
            }
        case .initialize:
            fetchUsdz()
            break
        case .showFailedAlert:
            state.alert = .init(title: .init("不明なエラーが発生しました"))
        case .dismissAlert:
            state.alert = nil
        case .completeAddAnchor:
            state.addAnchorState = .finishAddAnchor
            UserSetting.currentAnchorState = .finishAddAnchor
        case .disAppear:
            UserSetting.currentAnchorState = .normal
        }
        return .none
    }
    
    private func fetchUsdz() {
        let entity = try! ModelEntity.load(named: "cupcake.usdz")
        UserSetting.selectedModel = entity
    }
    
}
