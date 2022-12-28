//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/28.
//

import ARKit
import SwiftUI
import UIKit

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
    
    func faces(at index: Int, faces: ARGeometryElement) -> [Int] {
        let indicesPerFace = faces.indexCountPerPrimitive
        let facesPointer = faces.buffer.contents()
        var vertexIndices = [Int]()
        for offset in 0..<indicesPerFace {
            let vertexIndexAddress = facesPointer.advanced(by: (index * indicesPerFace + offset) * MemoryLayout<UInt32>.size)
            vertexIndices.append(Int(vertexIndexAddress.assumingMemoryBound(to: UInt32.self).pointee))
        }
        return vertexIndices
    }
    
}
