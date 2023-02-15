//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate

public extension Feature {

    static func classic<State: FeatureMachines>(
            _ initial: State,
            function: @escaping BiMapper<State, FeatureEvent<IntTrigger, ExtTrigger>, ClassicFeatureResult<State, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        Feature(initial) { machines, event in
            let result = function(machines, event)
            return FeatureTransition(
                    classic(
                            result.state,
                            function: function
                    ),
                    effects: result.effects
            )
        }
    }
}