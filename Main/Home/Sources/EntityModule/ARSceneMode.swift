//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/28.
//


public enum ARSceneMode: String, CaseIterable, Identifiable {
    case roomPlan
    case objectPutting
    public var description: String {
        switch self {
        case .roomPlan:
            return "AR sweet Room"
        case .objectPutting:
            return "Puts sweet"
        }
    }
    
    public var id: String { rawValue }
}

