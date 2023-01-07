//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/07.
//

import XCTest
import ComposableArchitecture
import RoomPlan
import simd
@testable import Home

@MainActor
final class ARScnFeatureTest: XCTestCase {
    let scheduler = DispatchQueue.test
    func test_起動時() {
        let store = TestStore(initialState: ARScnFeature.State(),
                            reducer: ARScnFeature())
        XCTAssertNil(store.state.alert)
        XCTAssertEqual(store.state.roomNodes.count, 0)
    }
    
//    func test_Node追加時() async {
////        let store = TestStore(initialState: ARScnFeature.State(),
////                              reducer: ARScnFeature())
////        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
////        let roomObject = RoomObjectAnchor(roomObjTransform: simd_float4x4(),
////                                          dimensions: simd_make_float3(0.0),
////                                          category: .bed)
////        let roomNode = RoomNode(roomObject: roomObject,
////                                uuid: UUID().uuidString)
////        let roomNodes: Set<RoomNode> = [roomNode]
////        let emptyNodes: Set<RoomNode> = []
////        await store.send(.addRoomNode(roomNode)) {
////            $0.roomNodes = roomNodes
////        }
////
////        await store.send(.removeRoomNode(roomNode)) {
////            $0.roomNodes = emptyNodes
////        }
//    }
}
