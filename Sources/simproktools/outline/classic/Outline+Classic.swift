//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    static func classic<State>(
        _ initial: State,
        function: @escaping (State, FeatureEvent<IntTrigger, ExtTrigger>) -> (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>])
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { trigger in
            let (newState, effects) = function(initial, trigger)
            return OutlineTransition(
                    classic(newState, function: function),
                    effects: effects
            )
        }
    }
    
    static func classic(
        function: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        classic(Void()) { state, trigger in
            (state, function(trigger))
        }
    }
}
