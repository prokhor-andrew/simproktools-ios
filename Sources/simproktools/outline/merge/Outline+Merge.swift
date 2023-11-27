//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 24.11.2023.
//

import simprokstate


public extension Outline {

    
    static func merge(
        _ outlines: [Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>]
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        Outline { trigger, logger in
            var effects: [FeatureEvent<IntEffect, ExtEffect>] = []
            
            let mapped = outlines.map { outline in
                let transition = outline.transit(trigger, logger)
                effects.append(contentsOf: transition.effects)
                return transition.state
            }
            
            return OutlineTransition(merge(mapped), effects: effects)
        }
    }
    
    static func merge(
        _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        merge(outlines)
    }
}
