//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public extension Feature {

    
    static func classic<State: FeatureMachines>(
        _ initial: State,
        function: @escaping (
            State,
            FeatureEvent<IntTrigger, ExtTrigger>,
            (Loggable) -> Void
        ) -> (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>])
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        Feature.create(initial) { machines, trigger, logger in
            let result = function(machines, trigger, logger)
            return FeatureTransition(.classic(result.newState, function: function), effects: result.effects)
        }
    }
}
