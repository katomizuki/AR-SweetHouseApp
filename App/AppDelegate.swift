//
//  AppDelegate.swift
//  RealitySuperApp
//
//  Created by ミズキ on 2022/10/20.
//
import UIKit
import SwiftUI
import Home
import ComposableArchitecture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let store = Store(initialState: HomeFeature.State(),
                          reducer: HomeFeature())
        let contentView = Home.HomeView(store: store)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

