//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate

public extension Feature {

    static func classic<State: FeatureMachines>(
            _ initial: State,
            function: @escaping BiMapper<State, FeatureEvent<IntTrigger, ExtTrigger>, ClassicResult<State, IntTrigger, IntEffect, ExtTrigger, ExtEffect>?>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where State.Trigger == IntTrigger, State.Effect == IntEffect {
        Feature(initial) { _, event in
            if let result = function(initial, event) {
                return FeatureTransition(
                        classic(
                                result.state,
                                function: function
                        ),
                        effects: result.effects
                )
            } else {
                return nil
            }
        }
    }
}