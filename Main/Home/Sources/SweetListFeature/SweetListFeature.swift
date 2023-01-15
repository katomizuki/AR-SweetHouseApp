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
import TabFeature

public struct SweetListFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var sweets: [Sweet] = [
            Sweet(name: "cupcake", thumbnail: "cupcake", description: "カップケーキ"),
            Sweet(name: "cookie", thumbnail: "cookie", description: "クッキー"),
            Sweet(name: "chocolate", thumbnail: "cookie", description: "チョコレート"),
            Sweet(name: "iceCream", thumbnail: "iceCream", description: "アイスクリーム"),
            Sweet(name: "donut", thumbnail: "donut", description: "ドーナッツ"),
        ]
        var detailState: SweetDetailFeature.State?
        var tabState: TabState
        var alert: AlertState<Action>?
        public init() {
            self.tabState = TabState()
        }
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
        }.ifLet(\.detailState,
                 action: /Action.detailAction) {
            SweetDetailFeature()
        }
    }
}

