//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import MetalKit
import RealityKit

final class  MetalLibraryLoader {
    static let shared = MetalLibraryLoader()
    private static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    private let library: MTLLibrary
    
    private init() {
        guard let library = Self.device.makeDefaultLibrary() else
        { fatalError("cant't make library") }
        self.library = library
    }
    
    func getGeometryModiferShader(metalShaderName :MetalShaderKeys) -> CustomMaterial.GeometryModifier {
        return CustomMaterial.GeometryModifier(named: metalShaderName.rawValue,
                                               in: library)
    }
    
    func getSurfaceShader(metalShaderName: MetalShaderKeys) -> CustomMaterial.SurfaceShader {
        return CustomMaterial.SurfaceShader(named: metalShaderName.rawValue,
                                            in: library)
    }
    
    func getPostProcessingShader(metalShaderName: MetalShaderKeys) -> MTLFunction? {
        return library.makeFunction(name: metalShaderName.rawValue)
    }
    
}
