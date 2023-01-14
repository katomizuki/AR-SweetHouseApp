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
        var sweets: IdentifiedArrayOf<Sweet> = [
            Sweet(name: "cupcake", thumbnail: "cupcake", description: "カップケーキ"),
            Sweet(name: "cookie", thumbnail: "cookie", description: "クッキー"),
            Sweet(name: "chocolate", thumbnail: "cookie", description: "チョコレート"),
            Sweet(name: "iceCream", thumbnail: "iceCream", description: "アイスクリーム"),
            Sweet(name: "donut", thumbnail: "donut", description: "ドーナッツ"),
        ]
        var selection: Identified<Sweet.ID, SweetDetailFeature.State>?
        var alert: AlertState<Action>?
        public init() { }
        public static func == (lhs: SweetListFeature.State, rhs: SweetListFeature.State) -> Bool {
            return true
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case detailAction(SweetDetailFeature.Action)
        case showFailedAlert
        case dismissAlert
    }
    
    @Dependency(\.firebaseClient) var firebaseClient
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
            case .detailAction:
                return .none
            case .showFailedAlert:
                state.alert = .init(title: .init("不明なエラーが発生しました"))
            case .dismissAlert:
                state.alert = nil
                return .none
            }
            return .none
        }.ifLet(\.selection,
                 action: /Action.detailAction) {
            Scope(state: \Identified<Sweet.ID, SweetDetailFeature.State>.value,
                  action: /.self) {
                SweetDetailFeature()
            }
        }
    }
}

