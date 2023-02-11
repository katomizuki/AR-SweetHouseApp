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
import Metal
import MetalKit

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
    /// Indexから法線を取り出すHelper
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
    // index=>頂点
    func vertex(at index: UInt32) -> SIMD3<Float> {
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return vertex
    }
    
    // index=>法線
    func normal(at index: UInt32) -> SIMD3<Float> {
        let normalPointer = normals.buffer.contents().advanced(by: normals.offset + (normals.stride * Int(index)))
        let normal = normalPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return normal
    }
    
    // index=>そのインデックスを構成する面の頂点配列
    func vertexIndicesOf(at index: Int) -> [Int] {
        let indicesPerFace = faces.indexCountPerPrimitive
        let facesPointer = faces.buffer.contents()
        var vertexIndices = [Int]()
        for offset in 0..<indicesPerFace {
            let vertexIndexAddress = facesPointer.advanced(by: (index * indicesPerFace + offset) * MemoryLayout<UInt32>.size)
            vertexIndices.append(Int(vertexIndexAddress.assumingMemoryBound(to: UInt32.self).pointee))
        }
        return vertexIndices
    }
    
    // テキスチャ座標の配列
    func buildCoordinates(modelMatrix: simd_float4x4,
                          camera: ARCamera) -> [SIMD2<Float>] {
                   let size = camera.imageResolution
                   let textureCoordinates = (0..<vertices.count).map { i -> vector_float2 in
                       let vertex = vertex(at: UInt32(i))
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
    
    // ModelMeshに変換　https://stackoverflow.com/questions/61063571/arkit-how-to-export-obj-from-iphone-ipad-with-lidar
    func toModelMesh(device: MTLDevice, camera: ARCamera, modelMatrix: simd_float4x4) -> MDLMesh {
        func convertVertexLocalToWorld() {
            // meshのポインタを取得
            let verticesPointer = vertices.buffer.contents()

            // 頂点の数だけloopするのでそのままIndexにすtかう
            for vertexIndex in 0..<vertices.count {
                let vertex = self.vertex(at: UInt32(vertexIndex))
                
                var vertexLocalTransform = matrix_identity_float4x4
                vertexLocalTransform.columns.3 = SIMD4<Float>(x: vertex.x, y: vertex.y, z: vertex.z, w: 1)
                // モデル行列を乗算してワールド座標系に変換
                let vertexWorldPosition = (modelMatrix * vertexLocalTransform).columns.3
                // ポインタのオフセットはバッファの開始地点(offset)にstrideにindexを乗算したものを使用
                let vertexOffset = vertices.offset + vertices.stride * vertexIndex
                // triangleなので3でわる
                let componentStride = vertices.stride / 3
                //ポインタのx,y,zにそれぞれ値を流し込めばOK Offset
                verticesPointer.storeBytes(of: vertexWorldPosition.x, toByteOffset: vertexOffset, as: Float.self)
                verticesPointer.storeBytes(of: vertexWorldPosition.y, toByteOffset: vertexOffset + componentStride, as: Float.self)
                verticesPointer.storeBytes(of: vertexWorldPosition.z, toByteOffset: vertexOffset + (2 * componentStride), as: Float.self)
            }
        }
        // モデル座標系=>ワールド座標系
        convertVertexLocalToWorld()
        
        let allocator = MTKMeshBufferAllocator(device: device);

        let data = Data.init(bytes: vertices.buffer.contents(), count: vertices.stride * vertices.count);
        let vertexBuffer = allocator.newBuffer(with: data, type: .vertex);

        let indexData = Data.init(bytes: faces.buffer.contents(), count: faces.bytesPerIndex * faces.count * faces.indexCountPerPrimitive);
        let indexBuffer = allocator.newBuffer(with: indexData, type: .index);

        let submesh = MDLSubmesh(indexBuffer: indexBuffer,
                                 indexCount: faces.count * faces.indexCountPerPrimitive,
                                 indexType: .uInt32,
                                 geometryType: .triangles,
                                 material: nil);

        let vertexDescriptor = MDLVertexDescriptor();
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                            format: .float3,
                                                            offset: 0,
                                                            bufferIndex: 0);
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: vertices.stride);

        let mesh = MDLMesh(vertexBuffer: vertexBuffer,
                       vertexCount: vertices.count,
                       descriptor: vertexDescriptor,
                       submeshes: [submesh])
        
        return mesh
        
    }
}
