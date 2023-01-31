//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/31.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {
    public var userDefaultsManager: UserDefaultsManager {
        get { self[UserDefaultsManager.self] }
        set { self[UserDefaultsManager.self] = newValue }
    }
}

extension UserDefaultsManager: DependencyKey {
    public static var liveValue: UserDefaultsManager {
        return UserDefaultsManager.shared
    }
}

final public class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    private init() { }
    
    public func saveARWorldFlag(flag: Bool) {
        UserDefaults.standard.setValue(flag, forKey: "arFlag")
    }
    
    public func loadARWorldFlag() -> Bool {
        return UserDefaults.standard.bool(forKey: "arFlag")
    }
}
