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
                                return (machines, [.ext(output)], false)
                            case .ext(let input):
                                return (machines, function(input).map { .int($0) }, false)
                            }
                        }
                )
        )
    }

    func mapInput<State, RInput>(
            with state: State,
            function: @escaping BiMapper<State, RInput, (newState: State, inputs: [Input])>
    ) -> Machine<RInput, Output> {
        Machine<RInput, Output>(
                FeatureTransition(
                        Feature.classic(DataMachines(state, machines: self)) { machines, trigger in
                            switch trigger {
                            case .int(let output):
                                return (machines, [.ext(output)], false)
                            case .ext(let input):
                                let (newState, inputs) = function(machines.data, input)

                                return (DataMachines(newState, machines: machines.machines), inputs.map { .int($0) }, false)
                            }
                        }
                )
        )
    }
}