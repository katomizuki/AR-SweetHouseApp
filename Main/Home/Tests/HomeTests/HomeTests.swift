import XCTest
import Quick
import Nimble
import ComposableArchitecture
@testable import Home

final class HomeTests: QuickSpec {
    
    override func spec() {
        let store = TestStore(initialState: HomeFeature.State(),
                            reducer: HomeFeature())
        describe("画面表示時") {
            context("PuttingViewを開く場合") {
                store.send(.togglePuttiingView) {
                    $0.isPuttingView.toggle()
                    expect(store.state.isSettingView).to(equal(true))
                }
            }
            
            context("おやつリスト画面を開く場合") {
                store.send(.toggleSweetListView) {
                    $0.isSweetListView.toggle()
                    expect(store.state.isSweetListView).to(equal(true))
                }
            }
            
            context("設定画面を開く場合") {
                store.send(.toggleSettingView) {
                    $0.isSettingView.toggle()
                    expect(store.state.isSettingView).to(equal(true))
                }
            }
        }
        
        
        describe("画面を閉じる時") {
            context("PuttingViewを閉じる場合") {
                store.send(.togglePuttiingView) {
                    $0.isPuttingView.toggle()
                    expect(store.state.isSettingView).to(equal(false))
                }
            }

            context("おやつリスト画面を閉じる場合") {
                store.send(.toggleSweetListView) {
                    $0.isSweetListView.toggle()
                    expect(store.state.isSweetListView).to(equal(false))
                }
            }

            context("設定画面を閉じる場合") {
                store.send(.toggleSettingView) {
                    $0.isSettingView.toggle()
                    expect(store.state.isSettingView).to(equal(false))
                }
            }
        }
    }
}
