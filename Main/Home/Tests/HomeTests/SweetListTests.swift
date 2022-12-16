//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import XCTest
import Quick
import Nimble
import ComposableArchitecture
@testable import SweetListFeature

final class SweetListTests: QuickSpec {
    
    override func spec() {
        let store = TestStore(initialState: SweetListFeature.State(),
                            reducer: SweetListFeature())
        
        describe("起動時") {
            context("数が0ではないか") {
                store.send(.onAppear)
                expect(store.state.sweets.count).notTo(equal(0))
            }
        }
    }
}
