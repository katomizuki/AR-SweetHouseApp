//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/13.
//

import ComposableArchitecture
import EntityModule
import SceneKit

public struct SweetDetailFeature: ReducerProtocol {
    
    public struct State: Equatable, Identifiable {
        public var id: UUID = UUID()
        public var sweet: Sweet
        var isVerticleLook: Bool = true
        var rotationEffect: Double = 90
        var offset: CGFloat = .zero
        var scene: SCNScene?
        var alert: AlertState<Action>?
        public init(_ sweet: Sweet) {
            self.sweet = sweet
            self.scene = SCNScene(named: "\(sweet.name).scn")
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case onTapNavigationTrailingButton
        case rotateObject(isOffsetZero: Bool)
        case changeOffset(_ newOffset: CGFloat)
        case showFailedAlert
        case dismissAlert
        case onTapDecideButton
    }
    
    public init() { }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            return .none
        case .onTapNavigationTrailingButton:
            state.isVerticleLook.toggle()
            state.rotationEffect = state.isVerticleLook ? 90 : 0
            return .none
        case .changeOffset(let newOffset):
            state.offset = newOffset
            return .none
        case .rotateObject(let animate):
            if animate {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.4
            }
            if state.isVerticleLook {
                let newAngle = Float((state.offset * .pi) / 180)
                state.scene?.rootNode.childNode(withName: "Root",
                                                    recursively: true)?.eulerAngles.y = newAngle
            } else {
                let newAngle = Float((state.offset * .pi) / 180)
                state.scene?.rootNode.childNode(withName: "Root",
                                                    recursively: true)?.eulerAngles.x = newAngle
            }
            if animate  {
                SCNTransaction.commit()
            }
        case .showFailedAlert:
            state.alert = .init(title: .init("不明なエラーが発生しました"))
        case .dismissAlert:
            state.alert = nil
        case .onTapDecideButton:
            UserSetting.selectedModel = state.sweet.entity
        }
        return .none
    }
}
