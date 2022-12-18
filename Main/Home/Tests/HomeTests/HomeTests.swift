import XCTest
import ComposableArchitecture
@testable import Home

class HomeTests: XCTestCase {
    let scheduler = DispatchQueue.test
    func test_画面表示時() {
        let store = TestStore(initialState: HomeFeature.State(),
                            reducer: HomeFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.togglePuttiingView) {
            $0.isPuttingView = true
        }
        
        store.send(.toggleSweetListView) {
            $0.isSweetListView = true
        }
        
        store.send(.toggleSettingView) {
            $0.isSettingView = true
        }
    }
}
