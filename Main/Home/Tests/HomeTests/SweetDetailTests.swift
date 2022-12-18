//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import XCTest
import ComposableArchitecture
@testable import SweetDetailFeature

final class SweetDetailTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    func test_起動時() {
        let store = TestStore(initialState: SweetDetailFeature.State(),
                            reducer: SweetDetailFeature())
        store.send(.onAppear)
        XCTAssertTrue(store.state.isVerticleLook)
        XCTAssertEqual(store.state.rotationEffect, 90)
        XCTAssertEqual(store.state.offset, .zero)
    }
    
    func test_Offset変更時() {
        let store = TestStore(initialState: SweetDetailFeature.State(),
                              reducer: SweetDetailFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.changeOffset(90.0)) {
            $0.offset = 90.0
        }
    }
    
    func test_ナビゲーションの左ボタンタップ時() {
        let store = TestStore(initialState: SweetDetailFeature.State(),
                            reducer: SweetDetailFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.onTapNavigationTrailingButton) {
            $0.rotationEffect = 0
            $0.isVerticleLook = false
        }
    }
}
