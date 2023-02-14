//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func mapInput<RInput>(_ function: @escaping Mapper<RInput, [Input]>) -> Machine<RInput, Output> {
        Machine<RInput, Output>(
                FeatureTransition(
                        Feature.classic(SetOfMachines(self)) { machines, trigger in
                            switch trigger {
                            case .int(let output):
                                return ClassicFeatureResult(machines, effects: .ext(output))
                            case .ext(let input):
                                return ClassicFeatureResult(machines, effects: function(input).map {
                                    .int($0)
                                })
                            }
                        }
                )
        )
    }

    func mapInput<State, RInput>(
            with state: State,
            function: @escaping BiMapper<State, RInput, MapWithStateResult<State, Input>>
    ) -> Machine<RInput, Output> {
        Machine<RInput, Output>(
                FeatureTransition(
                        Feature.classic(DataMachines(state, machines: self)) { machines, trigger in
                            switch trigger {
                            case .int(let output):
                                return ClassicFeatureResult(machines, effects: .ext(output))
                            case .ext(let input):
                                let mapped = function(state, input)

                                return ClassicFeatureResult(
                                        DataMachines(mapped.state, machines: machines.machines),
                                        effects: mapped.events.map {
                                            .int($0)
                                        }
                                )
                            }
                        }
                )
        )
    }
}