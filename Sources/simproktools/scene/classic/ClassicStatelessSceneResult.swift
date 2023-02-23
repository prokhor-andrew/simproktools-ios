//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 23.02.2023.
//

import simprokstate


public enum ClassicStatelessSceneResult<Effect> {
    case next([Effect])
    case finale([Effect])
    
    public var effects: [Effect] {
        switch self {
        case .next(let effects),
                .finale(let effects):
            return effects
        }
    }
}
