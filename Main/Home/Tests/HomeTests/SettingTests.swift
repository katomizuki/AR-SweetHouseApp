//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import XCTest
import ComposableArchitecture
@testable import SettingFeature

final class SettingTests: XCTestCase {
    let scheduler = DispatchQueue.test
    func test_起動時() {
        let store = TestStore(initialState: SettingFeature.State(),
                            reducer: SettingFeature())
        XCTAssertNil(store.state.alert)
    }
    func test_エラー時() {
        let store = TestStore(initialState: SettingFeature.State(),
                            reducer: SettingFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.showFailedAlert) {
            $0.alert = .init(title: .init("不明なエラーが発生しました"))
        }
        store.send(.dismissAlert) {
            $0.alert = nil
        }
    }
}
