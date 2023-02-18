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
        Feature.create(initial) { machines, event in
            let result = function(machines, event)
            if let newState = result.state {
                return FeatureTransition(
                        classic(
                                newState,
                                function: function
                        ),
                        effects: result.effects
                )
            } else {
                return FeatureTransition(
                        .finale(),
                        effects: result.effects
                )
            }
        }
    }
}