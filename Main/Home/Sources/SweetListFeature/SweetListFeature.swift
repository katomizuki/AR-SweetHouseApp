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
        var sweets = Sweets()
        var detailState: SweetDetailFeature.State?
        var alert: AlertState<Action>?
        var isNavigationActive: Bool = false
        public init() { }
        public static func == (lhs: SweetListFeature.State, rhs: SweetListFeature.State) -> Bool {
            return true
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case detailAction(SweetDetailFeature.Action)
        case showFailedAlert
        case setNavigation(isActive: Bool, sweet: Sweet)
        case dismissAlert
    }
    
    @Dependency(\.firebaseClient) var firebaseClient
    
    public init() { }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .none
            case .detailAction:
                return .none
            case .showFailedAlert:
                state.alert = .init(title: .init("不明なエラーが発生しました"))
            case .dismissAlert:
                state.alert = nil
            case .setNavigation(_, let sweet):
                state.detailState = SweetDetailFeature.State(sweet)
            }
            return .none
        }.ifLet( \.detailState, action: /Action.detailAction) {
            SweetDetailFeature()
        }
    }
}

