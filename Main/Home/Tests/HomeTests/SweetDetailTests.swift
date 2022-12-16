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
@testable import SweetDetailFeature

final class SweetDetailTests: QuickSpec {
    
    override func spec() {
        let store = TestStore(initialState: SweetDetailFeature.State(),
                            reducer: SweetDetailFeature())
        
        describe("起動時") {
            context("初期状態のテスト") {
                store.send(.onAppear)
                expect(store.state.isVerticleLook).to(equal(true))
                expect(store.state.rotationEffect).to(equal(90))
                expect(store.state.offset).to(equal(.zero))
            }
        }
        
        describe("offset変更時") {
            store.send(.changeOffset(90))
            expect(store.state.offset).to(equal(90))
        }
        
        describe("ナビゲーションの左ボタンタップ時") {
            store.send(.onTapNavigationTrailingButton)
            context("isVerticleLockがtoggle") {
                expect(store.state.isVerticleLook).to(equal(false))
            }
            context("回転軸が変わる") {
                expect(store.state.rotationEffect).to(equal(0))
            }
        }
    }
}
