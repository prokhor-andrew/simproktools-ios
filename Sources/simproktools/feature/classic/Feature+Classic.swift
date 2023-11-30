//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public extension Feature {

    
    static func classic<State: FeatureMachines>(
        _ initial: State,
        function: @escaping (
            FeatureExtras<State>,
            FeatureEvent<IntTrigger, ExtTrigger>
        ) -> (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>])
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        Feature.create(initial) { extras, trigger in
            let result = function(extras, trigger)
            return FeatureTransition(classic(result.newState, function: function), effects: result.effects)
        }
    }
}
