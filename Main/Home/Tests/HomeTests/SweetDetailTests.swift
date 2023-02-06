//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import XCTest
import ComposableArchitecture
@testable import SweetDetailFeature
@testable import EntityModule

final class SweetDetailTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    let sweet = Sweet(name: "アイウエオ", description: "uuu", usdzName: "aiueo", scale: 0.1)
    func test_起動時() {
        let store = TestStore(initialState: SweetDetailFeature.State(sweet),
                            reducer: SweetDetailFeature())
        store.send(.onAppear)
        XCTAssertTrue(store.state.isVerticleLook)
        XCTAssertEqual(store.state.rotationEffect, 90)
        XCTAssertEqual(store.state.offset, .zero)
    }
    
    func test_Offset変更時() {
        let store = TestStore(initialState: SweetDetailFeature.State(sweet),
                              reducer: SweetDetailFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.changeOffset(90.0)) {
            $0.offset = 90.0
        }
    }
    
    func test_ナビゲーションの左ボタンタップ時() {
        let store = TestStore(initialState: SweetDetailFeature.State(sweet),
                            reducer: SweetDetailFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.onTapNavigationTrailingButton) {
            $0.rotationEffect = 0
            $0.isVerticleLook = false
        }
    }
    
    func test_エラー時() {
        let store = TestStore(initialState: SweetDetailFeature.State(sweet),
                            reducer: SweetDetailFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.showFailedAlert) {
            $0.alert = .init(title: .init("Unknown error occurred."))
        }
        store.send(.dismissAlert) {
            $0.alert = nil
        }
    }
}
