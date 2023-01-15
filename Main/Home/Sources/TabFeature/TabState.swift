//
//  File.swift
//  
//
//  Created by ミズキ on 2023/01/15.
//

public struct TabState: Equatable {
    public var isSweetListView: Bool
    public var isPuttingView: Bool
    public var isSettingView: Bool
    public init(isSweetListView: Bool = false,
                isPuttingView: Bool = false,
                isSettingView: Bool = false) {
        self.isSweetListView = isSweetListView
        self.isPuttingView = isPuttingView
        self.isSettingView = isSettingView
    }
}
