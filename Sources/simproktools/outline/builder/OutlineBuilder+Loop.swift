//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate

public extension OutlineBuilder {
    
    func loop(
            _ function: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> (Bool, [FeatureEvent<IntEffect, ExtEffect>])
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        handle { state in
            @Sendable
            func provide() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
                Outline.create {
                    let (isLoop, effects) = function($0)
                    
                    if isLoop {
                        return OutlineTransition(
                            provide(),
                            effects: effects
                        )
                    } else {
                        return OutlineTransition(
                            state,
                            effects: effects
                        )
                    }
                }
            }
            
            return provide()
        }
    }
}
