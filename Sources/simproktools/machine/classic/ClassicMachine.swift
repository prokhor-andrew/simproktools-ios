//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func classic<State>(
            _ initial: ClassicMachineResult<State, Output>,
            function: @escaping BiMapper<State, Input, ClassicMachineResult<State, Output>>
    ) -> Machine<Input, Output> {
        Machine<Input, Output>(
                FeatureTransition(
                        Feature<Void, Void, Input, Output>.classic(initial.state, machines: EmptyMachines()) { payload, machines, event in
                            switch event {
                            case .int:
                                return ClassicResultWithPayload(payload, machines: machines)
                            case .ext(let trigger):
                                let result = function(payload, trigger)
                                return ClassicResultWithPayload(result.state, machines: machines, effects: result.outputs.map { .ext($0) })
                            }
                        },
                        effects: initial.outputs.map { .ext($0) }
                )
        )
    }
}
