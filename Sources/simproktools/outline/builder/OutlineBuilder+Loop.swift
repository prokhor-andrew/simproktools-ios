//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate

public extension OutlineBuilder {
    
    func loop(
        _ function: @escaping (OutlineExtras, FeatureEvent<IntTrigger, ExtTrigger>) -> (Bool, [FeatureEvent<IntEffect, ExtEffect>])
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        handle { state in
            @Sendable
            func provide() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
                Outline { extras, trigger in
                    let (isLoop, effects) = function(extras, trigger)
                    
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
