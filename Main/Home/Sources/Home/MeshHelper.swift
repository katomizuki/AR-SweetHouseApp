//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/28.
//

import ARKit
import SwiftUI
import UIKit
import RealityKit

final class MeshHelper {
    func getTextureImage(frame: ARFrame) -> Image? {
        let pixelBuffer = frame.capturedImage
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cameraImage = context.createCGImage(image, from: image.extent)
        else { return nil }
        let uiImage = UIImage(cgImage: cameraImage)
        return Image(uiImage: uiImage)
    }
    // Indexから頂点を割り出すHelper
    func vertex(at index: UInt32, vertices: ARGeometrySource) -> SIMD3<Float> {
        assert(vertices.format == MTLVertexFormat.float3,"not float3")
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return vertex
    }
    
    func normal(at index: UInt32, normals: ARGeometrySource) -> SIMD3<Float> {
        assert(normals.format == MTLVertexFormat.float3, "not float3")
        let normalPointer = normals.buffer.contents().advanced(by: normals.offset + (normals.stride * Int(index)))
        let normal = normalPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return normal
    }
    
    // Indexからその面を構成する頂点配列をゲットする。
    func vertexIndicesOf(at index: Int, faces: ARGeometryElement) -> [Int] {
        let indicesPerFace = faces.indexCountPerPrimitive
        let facesPointer = faces.buffer.contents()
        var vertexIndices = [Int]()
        for offset in 0..<indicesPerFace {
            let vertexIndexAddress = facesPointer.advanced(by: (index * indicesPerFace + offset) * MemoryLayout<UInt32>.size)
            vertexIndices.append(Int(vertexIndexAddress.assumingMemoryBound(to: UInt32.self).pointee))
        }
        return vertexIndices
    }
    
    
    func buildCoordinates(modelMatrix: simd_float4x4,
                          camera: ARCamera,
                          vertices: ARGeometrySource) -> [SIMD2<Float>] {
                   let size = camera.imageResolution
                   let textureCoordinates = (0..<vertices.count).map { i -> vector_float2 in
                       let vertex = vertex(at: UInt32(i), vertices: vertices)
                       let vertex4 = vector_float4(vertex.x, vertex.y, vertex.z, 1)
                       let world_vertex4 = simd_mul(modelMatrix, vertex4)
                       let world_vector3 = simd_float3(x: world_vertex4.x, y: world_vertex4.y, z: world_vertex4.z)
                       let pt = camera.projectPoint(world_vector3,
                           orientation: .portrait,
                           viewportSize: CGSize(
                               width: CGFloat(size.height),
                               height: CGFloat(size.width)))
                       let v = 1.0 - Float(pt.x) / Float(size.height)
                       let u = Float(pt.y) / Float(size.width)
                       return simd_float2(u, v)
                   }
                   return textureCoordinates
        }
}
extension ARMeshGeometry {
    func classificationOf(index: Int) -> ARMeshClassification {
        guard let classification = classification else  { return .none }
        let classificationPointer = classification.buffer.contents().advanced(by: classification.offset + (classification.stride * index))
        let classificationValue = Int(classificationPointer.assumingMemoryBound(to: CUnsignedChar.self).pointee)
        return ARMeshClassification(rawValue: classificationValue) ?? .none
    }
}
