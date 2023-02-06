//
//  WorldMapFeature.swift
//  
//
//  Created by ミズキ on 2022/11/26.
//

import ARKit
import ComposableArchitecture
import UtilFeature

extension DependencyValues {
    public var worldMap: WorldMapFeature {
        get { self[WorldMapFeature.self] }
        set { self[WorldMapFeature.self] = newValue }
    }
}
extension WorldMapFeature: DependencyKey {
    public static var liveValue: WorldMapFeature {
        return WorldMapFeature()
    }
}

public struct WorldMapFeature {

    public func writeWorldMap(_ worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap,
                                                    requiringSecureCoding: true)
        UserDefaultsManager.shared.saveData(data)
        try data.write(to: self.makeURL(), options: [.atomic])
    }
    
    public func loadWorldMap() throws -> ARWorldMap {
        let mapData = try Data(contentsOf: self.makeURL())
        guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData) else { throw ARError(.invalidWorldMap) }
        return worldMap
    }
    public init() { }
    
    private func makeURL() -> URL {
        do {
            // map.ar....で保
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }
    
    public func getCurrentWorldMap(_ session: ARSession?) async throws -> ARWorldMap {
        guard let session = session else { throw ARError(.requestFailed) }
        return try await withCheckedThrowingContinuation({ continuation in
             getWorldMap(session) { result in
                 do {
                     let worldMap = try result.get()
                     continuation.resume(returning: worldMap)
                 } catch {
                     continuation.resume(throwing: error)
                 }
             }
         })
     }
     
     private func getWorldMap(_ session: ARSession,
                              completion: @escaping (Result<ARWorldMap, Error>) -> Void) {
         session.getCurrentWorldMap { worldMap, error in
             if let error = error {
                 completion(.failure(error))
             }
             if let worldMap = worldMap {
                 completion(.success(worldMap))
             }
         }
     }
}
