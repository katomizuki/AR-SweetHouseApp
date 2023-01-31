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
            SweetDetailFeature.State(Sweet(name: "Cupcake",
                                           description: "A cupcake is a small cake designed to serve one person, which is baked in a cup-shaped mold. It is often topped with frosting or other decorations and comes in a variety of flavors.")),
            SweetDetailFeature.State(Sweet(name: "Cookie",
                                           description: "A cookie is a sweet baked good that is typically small, flat, and round. It is made from a mixture of flour, sugar, butter or oil, and other ingredients such as eggs, chocolate chips, or nuts. Cookies are often enjoyed as a snack or dessert.")),
            SweetDetailFeature.State(Sweet(name: "Chocolate",
                                           description: "Chocolate is a sweet, usually brown, food made from cacao beans, cocoa butter, sugar, and other ingredients such as milk or vanilla. It is used as an ingredient in a wide range of sweet foods and drinks, including chocolate bars, cakes, and hot chocolate. It is known for its rich, creamy texture and sweet, slightly bitter taste.")),
            SweetDetailFeature.State(Sweet(name: "Icecream",
                                           description: "Ice cream is a frozen dessert made from a mixture of cream, sugar, and flavorings, such as fruit or chocolate. It is usually served as a scoop or in a cone, and is a popular treat in many countries around the world, especially during hot weather. It can be made at home or purchased pre-made from a store.")),
            SweetDetailFeature.State(Sweet(name: "Donut",
                                           description: "A donut (also spelled doughnut) is a sweet, fried pastry, often shaped like a ring or a ball. It is typically made from a sweet dough, which is deep-fried and then coated with sugar or glaze. Donuts are a popular treat and come in a variety of flavors, such as chocolate, jelly-filled, or powdered sugar.")),
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
                state.alert = .init(title: .init("Unknown error occurred."))
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

