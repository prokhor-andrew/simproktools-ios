//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 08.04.2023.
//

import simprokmachine
import simprokstate


public extension Outline {
    
    func switchTo(
        doneOnFinale: Bool = true,
        function: @escaping (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>, FeatureEvent<IntTrigger, ExtTrigger>) ->
            OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>?
        
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        if doneOnFinale {
            if let transit {
                return Outline.create { trigger in
                    if let transition = function(self, trigger) {
                        return transition
                    } else {
                        if let transition = transit(trigger) {
                            return OutlineTransition(
                                transition.state.switchTo(doneOnFinale: doneOnFinale, function: function),
                                effects: transition.effects
                            )
                        } else {
                            return nil
                        }
                    }
                }
            } else {
                return .finale()
            }
        } else {
            return Outline.create { trigger in
                if let transition = function(self, trigger) {
                    return transition
                } else {
                    if let transit, let transition = transit(trigger) {
                        return OutlineTransition(
                            transition.state.switchTo(doneOnFinale: doneOnFinale, function: function),
                            effects: transition.effects
                        )
                    } else {
                        return nil
                    }
                }
            }
        }
    }
}
