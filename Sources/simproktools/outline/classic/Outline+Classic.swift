//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate

public extension Outline {

    static func classic<State>(
            _ initial: State,
            function: @escaping BiMapper<State, FeatureEvent<IntTrigger, ExtTrigger>, (newState: State?, effects: [FeatureEvent<IntEffect, ExtEffect>])>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline.create { trigger in
            let (newState, effects) = function(initial, trigger)

            if let newState = newState {
                return OutlineTransition(
                        classic(newState, function: function),
                        effects: effects
                )
            } else {
                return OutlineTransition(.finale(), effects: effects)
            }
        }
    }
    
    static func classic(
        function: @escaping Mapper<FeatureEvent<IntTrigger, ExtTrigger>, (effects: [FeatureEvent<IntEffect, ExtEffect>], isFinale: Bool)>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        classic(Void()) { state, trigger in
            let (effects, isFinale) = function(trigger)
            if isFinale {
                return (state, effects)
            } else {
                return (nil, effects)
            }
        }
    }
}
