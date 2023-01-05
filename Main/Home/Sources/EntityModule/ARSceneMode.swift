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
            return "部屋のものをお菓子にみたてて遊んでみよう！"
        case .objectPutting:
            return "好きにお菓子を配置しよう!!"
        }
    }
    
    public var id: String { rawValue }
}

