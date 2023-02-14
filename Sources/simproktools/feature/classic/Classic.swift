//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate

public extension Feature {

    static func classic<State: FeatureMachines>(
            _ initial: State,
            function: @escaping BiMapper<State, FeatureEvent<IntTrigger, ExtTrigger>, ClassicResult<State, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
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

    static func classic<Payload, Machines: FeatureMachines>(
            _ initial: Payload,
            machines: Machines,
            function: @escaping TriMapper<Payload, Machines, FeatureEvent<IntTrigger, ExtTrigger>, ClassicResultWithPayload<Payload, Machines, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where Machines.Trigger == IntTrigger, Machines.Effect == IntEffect {
        Feature(machines) {
            let result = function(initial, $0, $1)
            return FeatureTransition(
                    classic(
                            result.payload,
                            machines: result.machines,
                            function: function
                    ),
                    effects: result.effects
            )
        }
    }
}