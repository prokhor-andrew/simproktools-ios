//
// Created by Andriy Prokhorenko on 20.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func biMap<State, RInput, ROutput>(
            _ state: Supplier<State>,
            mapInput: @escaping BiMapper<State, RInput, (State, [Input])>,
            mapOutput: @escaping BiMapper<State, Output, (State, [ROutput])>
    ) -> Machine<RInput, ROutput> {
        Machine<RInput, ROutput>(
                FeatureTransition(
                        Feature.classic(DataMachines(state(), machines: self)) { machines, trigger in
                            switch trigger {
                            case .int(let output):
                                let (newState, newOutputs) = mapOutput(machines.data, output)

                                return ClassicFeatureResult(
                                        DataMachines(newState, machines: machines.machines),
                                        effects: newOutputs.map {
                                            .ext($0)
                                        }
                                )
                            case .ext(let input):
                                let (newState, newInputs) = mapInput(machines.data, input)

                                return ClassicFeatureResult(
                                        DataMachines(newState, machines: machines.machines),
                                        effects: newInputs.map {
                                            .int($0)
                                        }
                                )
                            }
                        }
                )
        )
    }
}
