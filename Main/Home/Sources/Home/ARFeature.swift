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
        public static func == (lhs: ARFeature.Action, rhs: ARFeature.Action) -> Bool {
            return true
        }
    }
    
    public struct State: Equatable {
        var isSelectedModel = false
        var selectedModel: ModelEntity?
        var arSession: ARSession?
        var roomSession: RoomCaptureSession?
        var alert: AlertState<Action>?
        
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
        case .initialize:
            state.selectedModel = UserSetting.selectedModel
            break
        case .showFailedAlert:
            state.alert = .init(title: .init("不明なエラーが発生しました"))
        case .dismissAlert:
            state.alert = nil
        }
        return .none
    }
    
}
