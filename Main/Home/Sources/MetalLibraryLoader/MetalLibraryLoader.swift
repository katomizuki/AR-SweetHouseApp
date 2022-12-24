//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import MetalKit
import RealityKit
import ComposableArchitecture

extension DependencyValues {
    public var metalLoader: MetalLibraryLoader {
        get { self[MetalLibraryLoader.self] }
        set { self[MetalLibraryLoader.self] = newValue }
    }
}
extension MetalLibraryLoader: DependencyKey {
    public static var liveValue: MetalLibraryLoader{
        return MetalLibraryLoader.shared
    }
}

public final class MetalLibraryLoader {
    public static let shared = MetalLibraryLoader()
    private static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    private let library: MTLLibrary
    
    private init() {
        guard let library = Self.device.makeDefaultLibrary() else
        { fatalError("cant't make library") }
        self.library = library
    }
    
    public func getGeometryModiferShader(metalShaderName :MetalShaderKeys) -> CustomMaterial.GeometryModifier {
        return CustomMaterial.GeometryModifier(named: metalShaderName.rawValue,
                                               in: library)
    }
    
    public func getSurfaceShader(metalShaderName: MetalShaderKeys) -> CustomMaterial.SurfaceShader {
        return CustomMaterial.SurfaceShader(named: metalShaderName.rawValue,
                                            in: library)
    }
    
    public func getPostProcessingShader(metalShaderName: MetalShaderKeys) -> MTLFunction? {
        return library.makeFunction(name: metalShaderName.rawValue)
    }
    
}
