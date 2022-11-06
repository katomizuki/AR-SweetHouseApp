//
//  AppDelegate.swift
//  RealitySuperApp
//
//  Created by ミズキ on 2022/10/20.
//

import UIKit
import SwiftUI
import Home

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Create the SwiftUI view that provides the window contents.
        let contentView = Home.ContentView()
//        FirebaseApp.configure()
        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

