//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    static func classic<State>(
        _ initial: @autoclosure @escaping () -> State,
        function: @escaping (State, FeatureEvent<IntTrigger, ExtTrigger>, (Message) -> Void) -> (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>])
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        Outline { trigger, logger in
            let (newState, effects) = function(initial(), trigger, logger)
            return OutlineTransition(
                classic(newState, function: function),
                effects: effects
            )
        }
    }
    
    static func classic(
        function: @escaping (FeatureEvent<IntTrigger, ExtTrigger>, (Message) -> Void) -> [FeatureEvent<IntEffect, ExtEffect>]
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        classic(Void()) { state, trigger, logger in
            (state, function(trigger, logger))
        }
    }
}
