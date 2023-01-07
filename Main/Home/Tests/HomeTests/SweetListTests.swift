//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import XCTest
import ComposableArchitecture
@testable import SweetListFeature

final class SweetListTests: XCTestCase {
    let scheduler = DispatchQueue.test
    func test_起動時() {
        let store = TestStore(initialState: SweetListFeature.State(),
                            reducer: SweetListFeature())
        XCTAssertNil(store.state.alert)
        XCTAssertNotNil(store.state.detailState)
    }
}
