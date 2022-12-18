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
    
    func test_起動時() {
        let store = TestStore(initialState: SweetListFeature.State(),
                            reducer: SweetListFeature())
        store.send(.onAppear)
        XCTAssertNotEqual(store.state.sweets.count, 0)
    }
}
