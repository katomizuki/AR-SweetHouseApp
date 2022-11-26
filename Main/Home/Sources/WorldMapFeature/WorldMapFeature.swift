//
//  WorldMapFeature.swift
//  
//
//  Created by ミズキ on 2022/11/26.
//

import ARKit

struct WorldMapFeature {

    func writeWorldMap(_ worldMap: ARWorldMap) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap,
                                                    requiringSecureCoding: true)
        try data.write(to: self.makeURL())
    }
    
    func loadWorldMap() throws -> ARWorldMap {
        let mapData = try Data(contentsOf: self.makeURL())
        guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData) else { throw ARError(.invalidWorldMap) }
        return worldMap
    }
    
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
}
