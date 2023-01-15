//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/24.
//

import XCTest
import ComposableArchitecture
@testable import Home

final class ARFeatureTest: XCTestCase {
    let scheduler = DispatchQueue.test
    func test_起動時() {
        let store = TestStore(initialState: ARFeature.State(),
                            reducer: ARFeature())
        XCTAssertNil(store.state.selectedModel)
        XCTAssertNil(store.state.alert)
        XCTAssertNil(store.state.selectedModel)
        XCTAssertNil(store.state.arSession)
    }
}

