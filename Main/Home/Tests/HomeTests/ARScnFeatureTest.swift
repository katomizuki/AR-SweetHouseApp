//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/07.
//

import XCTest
import ComposableArchitecture
@testable import Home

final class ARScnFeatureTest: XCTestCase {
    let scheduler = DispatchQueue.test
    func test_起動時() {
        let store = TestStore(initialState: ARScnFeature.State(),
                            reducer: ARScnFeature())
        XCTAssertNil(store.state.alert)
        XCTAssertEqual(store.state.roomNodes.count, 0)
    }
}
