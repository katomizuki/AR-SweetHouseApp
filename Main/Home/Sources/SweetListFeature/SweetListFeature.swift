//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import ComposableArchitecture
import EntityModule
import SwiftUI
import SweetDetailFeature
import FirebaseClient

public struct SweetListFeature: ReducerProtocol {
    
    public struct State: Equatable {
        public var detailStates: IdentifiedArrayOf<SweetDetailFeature.State> =
        [
            SweetDetailFeature.State(Sweet(name: "cupcake",
                                           description: "カップケーキ")),
            SweetDetailFeature.State(Sweet(name: "cookie",
                                           description: "クッキー")),
            SweetDetailFeature.State(Sweet(name: "chocolate",
                                           description: "チョコレート")),
            SweetDetailFeature.State(Sweet(name: "iceCream",
                                           description: "アイスクリーム")),
            SweetDetailFeature.State(Sweet(name: "donut",
                                           description: "ドーナッツ")),
        ]
        var alert: AlertState<Action>?
        public init() { }
        public static func == (lhs: SweetListFeature.State, rhs: SweetListFeature.State) -> Bool {
            return true
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case detailAction(id: SweetDetailFeature.State.ID,
                          action: SweetDetailFeature.Action)
        case showFailedAlert
        case dismissAlert
        case dismissAll
    }
    
    @Dependency(\.mainQueue) var mainQueue
    private enum CancelID {}
    
    public init() { }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .none
            case .onDisappear:
                return .cancel(id: CancelID.self)
            case .detailAction(_, let action):
                if action == .onTapDecideButton {
                    return .task {
                        return .dismissAll
                    }
                }
                return .none
            case .showFailedAlert:
                state.alert = .init(title: .init("不明なエラーが発生しました"))
            case .dismissAlert:
                state.alert = nil
                return .none
            case .dismissAll:
                return .none
            }
            return .none
        }.forEach(\.detailStates,
                  action: /Action.detailAction(id:action:)) {
            SweetDetailFeature()
        }
    }
}

