//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public extension Feature {

    
    static func classic<State: FeatureMachines>(
            _ initial: State,
            function: @escaping BiMapper<State, FeatureEvent<IntTrigger, ExtTrigger>, (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>], isFinale: Bool)>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        Feature.create(initial) { machines, trigger in
            let result = function(machines, trigger)
            if result.isFinale {
                return FeatureTransition(.finale(result.newState), effects: result.effects)
            } else {
                return FeatureTransition(.classic(result.newState, function: function), effects: result.effects)
            }
        }
    }
}
