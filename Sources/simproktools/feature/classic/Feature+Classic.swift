//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate

public extension Feature {

    static func classic<State: FeatureMachines>(
            _ initial: State,
            info: String,
            function: @escaping TriMapper<State, String, FeatureEvent<IntTrigger, ExtTrigger>, ClassicFeatureResult<State, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        Feature(initial, info: info) { machines, info, event in
            let result = function(machines, info, event)
            return FeatureTransition(
                    classic(
                            result.state,
                            info: result.info,
                            function: function
                    ),
                    effects: result.effects
            )
        }
    }

    static func classic<State: FeatureMachines>(
            _ initial: State,
            function: @escaping BiMapper<State, FeatureEvent<IntTrigger, ExtTrigger>, ClassicFeatureResult<State, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        classic(initial, info: "") { machines, _, event in
            function(machines, event)
        }
    }
}