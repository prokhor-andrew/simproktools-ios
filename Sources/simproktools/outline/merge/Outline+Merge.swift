//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 24.11.2023.
//

import simprokstate


public extension Outline {

    
    static func merge(
        _ outlines: [Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>]
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { trigger in
            var effects: [FeatureEvent<IntEffect, ExtEffect>] = []
            
            let mapped = outlines.map { outline in
                let transition = outline.transit(trigger)
                effects.append(contentsOf: transition.effects)
                return transition.state
            }
            
            return OutlineTransition(merge(mapped), effects: effects)
        }
    }
    
    static func merge(
        _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        merge(outlines)
    }
}
