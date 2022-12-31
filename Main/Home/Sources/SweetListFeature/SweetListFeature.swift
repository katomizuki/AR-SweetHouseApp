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

let list = [Sweet(name: "a", thumnail: "apple.logo", description: "説明"),
              Sweet(name: "b", thumnail: "apple.logo", description: "説明"),
              Sweet(name: "c", thumnail: "apple.logo", description: "説明")]

public struct SweetListFeature: ReducerProtocol {
    
    public struct State: Equatable {
        var sweets = Sweets(list: list)
        var detailState = SweetDetailFeature.State()
        var alert: AlertState<Action>?
        public init() { }
        public static func == (lhs: SweetListFeature.State, rhs: SweetListFeature.State) -> Bool {
            return true
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case showFailedAlert
        case detailAction(SweetDetailFeature.Action)
        case changeSweets(sweets: Sweets)
        case dismissAlert
    }
    
    @Dependency(\.firebaseClient) var firebaseClient
    
    public init() { }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state , action in
            switch action {
            case .onAppear:
                return .task {
                    do {
                        let sweets =  try await firebaseClient.fetchSweets()
                        return .changeSweets(sweets: sweets)
                    } catch {
                        return .showFailedAlert
                    }
                }
            case .detailAction:
                return .none
            case .showFailedAlert:
                state.alert = .init(title: .init("通信に失敗しました"))
                return .none
            case .changeSweets(let sweets):
                state.sweets = sweets
            case .dismissAlert:
                state.alert = nil
            }
            return .none
        }
        
        Scope(state: \.detailState, action: /Action.detailAction) {
            SweetDetailFeature()
        }
    }
}

