//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokstate


public extension Outline {
    
    func doOnGuard(
        function: @escaping @Sendable (FeatureEvent<IntTrigger, ExtTrigger>) -> Void
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        if let transit {
            return Outline.create { trigger in
                if let transition = transit(trigger) {
                    return OutlineTransition(
                        transition.state.doOnGuard(function: function),
                        effects: transition.effects
                    )
                } else {
                    function(trigger)
                    return nil
                }
            }
        } else {
            return Outline.finale()
        }
    }
}
