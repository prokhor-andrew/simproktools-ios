//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 23.02.2023.
//

import simprokstate


public enum ClassicStatelessResult<IntEffect, ExtEffect> {
    case next([FeatureEvent<IntEffect, ExtEffect>])
    case finale([FeatureEvent<IntEffect, ExtEffect>])
    
    public var effects: [FeatureEvent<IntEffect, ExtEffect>] {
        switch self {
        case .next(let effects),
                .finale(let effects):
            return effects
        }
    }
}
