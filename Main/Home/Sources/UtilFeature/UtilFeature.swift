//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/10.
//

import RealityKit


extension Entity {
    // Entityのエクステンションメソッド
    func distance(from other: Entity) -> Float {
        // 引数に設定したEntityとの距離を返す
        transform.translation.distance(from: other.transform.translation)
    }
    
    func distance(from point: SIMD3<Float>) -> Float {
        // 引数に設定した点との距離をはかる
        transform.translation.distance(from: point)
    }

    func isDistanceWithinThreshold(from other: Entity, max: Float) -> Bool {
        // 引数に入れたEntityが閾値より遠いかどうかを算出。
        isDistanceWithinThreshold(from: transform.translation, max: max)
    }

    // 同様
    func isDistanceWithinThreshold(from point: SIMD3<Float>, max: Float) -> Bool {
        transform.translation.distance(from: point) < max
    }
}

extension SIMD3 where Scalar == Float {
    func distance(from other: SIMD3<Float>) -> Float {
        return simd_distance(self, other)
    }

    var printed: String {
        String(format: "(%.8f, %.8f, %.8f)", x, y, z)
    }

    static func spawnPoint(from: SIMD3<Float>, radius: Float) -> SIMD3<Float> {
        from + (radius == 0 ? .zero : SIMD3<Float>.random(in: Float(-radius)..<Float(radius)))
    }

    func angle(other: SIMD3<Float>) -> Float {
        atan2f(other.x - self.x, other.z - self.z) + Float.pi
    }

    var length: Float { return distance(from: .init()) }

    var isNaN: Bool {
        x.isNaN || y.isNaN || z.isNaN
    }

    var normalized: SIMD3<Float> {
        return self / length
    }

    static let up: Self = .init(0, 1, 0)

    func vector(to b: SIMD3<Float>) -> SIMD3<Float> {
        b - self
    }

    var isVertical: Bool {
        dot(self, Self.up) > 0.9
    }
}

extension SIMD2 where Scalar == Float {
    func distance(from other: Self) -> Float {
        return simd_distance(self, other)
    }

    var length: Float { return distance(from: .init()) }
}

extension BoundingBox {

    var volume: Float { extents.x * extents.y * extents.z }
}
