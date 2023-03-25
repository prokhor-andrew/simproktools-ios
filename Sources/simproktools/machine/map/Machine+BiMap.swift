//
// Created by Andriy Prokhorenko on 20.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func biMap<State, RInput, ROutput>(
            _ state: Supplier<State>,
            mapInput: @escaping BiMapper<State, RInput, (newState: State, inputs: [Input])>,
            mapOutput: @escaping BiMapper<State, Output, (newState: State, outputs: [ROutput])>
    ) -> Machine<RInput, ROutput> {
        Machine<RInput, ROutput>(
                FeatureTransition(
                        Feature.classic(DataMachines(state(), machines: self)) { machines, trigger in
                            switch trigger {
                            case .int(let output):
                                let (newState, outputs) = mapOutput(machines.data, output)

                                return (
                                        DataMachines(newState, machines: machines.machines),
                                        outputs.map { .ext($0) },
                                        false
                                )
                            case .ext(let input):
                                let (newState, inputs) = mapInput(machines.data, input)

                                return (
                                        DataMachines(newState, machines: machines.machines),
                                        inputs.map { .int($0) },
                                        false
                                )
                            }
                        }
                )
        )
    }
}