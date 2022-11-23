//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/23.
//

import ComposableArchitecture

struct HomeFeature: ReducerProtocol {
    
    typealias State = HomeState
    typealias Action = HomeAction
    
    struct HomeState: Equatable {
        
    }
    
    enum HomeAction: Equatable {
        case onApear
    }
    // Effectを使用する場合はEffect型を返す。
    func reduce(into state: inout HomeState, action: HomeAction) -> ComposableArchitecture.Effect<HomeAction, Never> {
        switch action {
        case .onApear:
            return .none
        }
    }
}
