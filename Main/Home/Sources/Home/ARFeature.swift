//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/22.
//

import ComposableArchitecture
import RealityKit
import ARKit

public struct ARFeature: ReducerProtocol {
    public var function: MTLFunction?
    
    public enum Action: Equatable {
        case subscriveEvent(session: ARSession?)
        case onTouchARView
        case initialize
    }
    
    public struct State: Equatable {
        var isSelectedModel = false
        var selectedModel: ModelEntity?
        var postProcessingShader1: MTLFunction?
        var postProcessiingShader2: MTLFunction?
        var arSession: ARSession?
        
        
        public static func == (lhs: ARFeature.State, rhs: ARFeature.State) -> Bool {
            return true
        }
    }
    
    @Dependency(\.metalLoader) var metalLoader
    
   public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onTouchARView:
            state.isSelectedModel = false
        case .subscriveEvent(let arSession):
            state.arSession = arSession
        case .initialize:
          let suisai = metalLoader.getPostProcessingShader(metalShaderName: .suisai)
          let toon = metalLoader.getPostProcessingShader(metalShaderName: .toon)
          state.postProcessingShader1 = suisai
          state.postProcessiingShader2 = toon
        }
        return .none
    }
    
}
