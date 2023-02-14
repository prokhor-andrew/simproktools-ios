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
                        Feature<Void, Void, Input, Output>.classic(DataMachines(initial.state)) { machines, event in
                            switch event {
                            case .int:
                                return ClassicFeatureResult(machines)
                            case .ext(let trigger):
                                let result = function(machines.data, trigger)
                                return ClassicFeatureResult(DataMachines(result.state, machines: machines.machines), effects: result.outputs.map {
                                    .ext($0)
                                })
                            }
                        },
                        effects: initial.outputs.map {
                            .ext($0)
                        }
                )
        )
    }
}
