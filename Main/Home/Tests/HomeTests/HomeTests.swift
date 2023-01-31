import XCTest
import ComposableArchitecture
@testable import Home

class HomeTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func test_起動時() {
        let store = TestStore(initialState: HomeFeature.State(),
                            reducer: HomeFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        XCTAssertFalse(store.state.tabState.isSweetListView)
        XCTAssertFalse(store.state.tabState.isSettingView)
        XCTAssertFalse(store.state.canUseApp)
        XCTAssertNil(store.state.alert)
        XCTAssertNotNil(store.state.settingState)
        XCTAssertNotNil(store.state.arViewState)
        XCTAssertEqual(store.state.currentARSceneMode, .objectPutting)
    }
    func test_画面表示時() {
        let store = TestStore(initialState: HomeFeature.State(),
                            reducer: HomeFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
      
        store.send(.toggleSweetListView) {
            $0.tabState.isSweetListView = true
        }
        
        store.send(.toggleSettingView) {
            $0.tabState.isSettingView = true
        }
    }
    
    func test_アプリ使えない時() {
        let store = TestStore(initialState: HomeFeature.State(),
                              reducer: HomeFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        
        store.send(.toggleCanUseApp) {
            $0.canUseApp = true
        }
    }
    
    func test_ShowAlert時() {
        let store = TestStore(initialState: HomeFeature.State(),
                              reducer: HomeFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.showCompleteAlert) {
            $0.alert = .init(title: .init("AR world successfully saved!"))
        }
        

        store.send(.alertDismiss) {
            $0.alert = nil
        }
        
        store.send(.showFailAlert) {
            $0.alert = .init(title: .init("Failed to save AR world"))
        }
        
        store.send(.showDontUseAppAlert) {
            $0.alert = .init(title: .init("This application can only be used on IPhone with iOS16 or higher and Lidar."))
        }
    }
    
    func test_Segmentタップ時() {
        let store = TestStore(initialState: HomeFeature.State(),
                              reducer: HomeFeature())
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.send(.onTapSegment) {
            $0.currentARSceneMode = .roomPlan
        }
    }
}
