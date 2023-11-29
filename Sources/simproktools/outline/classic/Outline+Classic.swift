//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate

public extension Outline {

    static func classic<State>(
        _ initial: @autoclosure @escaping () -> State,
        function: @escaping (State, FeatureEvent<IntTrigger, ExtTrigger>, (Loggable) -> Void) -> (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>])
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { extras, trigger in
            let (newState, effects) = function(initial(), trigger, extras.logger)
            return OutlineTransition(
                classic(newState, function: function),
                effects: effects
            )
        }
    }
    
    static func classic(
        function: @escaping (FeatureEvent<IntTrigger, ExtTrigger>, (Loggable) -> Void) -> [FeatureEvent<IntEffect, ExtEffect>]
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        classic(Void()) { state, trigger, logger in
            (state, function(trigger, logger))
        }
    }
}
