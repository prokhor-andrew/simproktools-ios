//
// Created by Andriy Prokhorenko on 20.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func biMap<RInput, ROutput>(
        mapInput: @escaping (RInput, (String) -> Void) -> [Input],
        mapOutput: @escaping (Output, (String) -> Void) -> [ROutput]
    ) -> Machine<RInput, ROutput> {
        biMap { Void() } mapInput: { state, input, logger in
            (state, mapInput(input, logger))
        } mapOutput: { state, output, logger in
            (state, mapOutput(output, logger))
        }
    }
    
    func biMap<State, RInput, ROutput>(
            with state: @escaping () -> State,
            mapInput: @escaping (State, RInput, (String) -> Void) -> (newState: State, inputs: [Input]),
            mapOutput: @escaping (State, Output, (String) -> Void) -> (newState: State, outputs: [ROutput])
    ) -> Machine<RInput, ROutput> {
        Machine<RInput, ROutput> { 
            Feature.classic(DataMachines(state(), machines: self)) { machines, trigger, logger in
                switch trigger {
                case .int(let output):
                    let (newState, outputs) = mapOutput(machines.data, output, logger)

                    return (
                            DataMachines(newState, machines: machines.machines),
                            outputs.map { .ext($0) }
                    )
                case .ext(let input):
                    let (newState, inputs) = mapInput(machines.data, input, logger)

                    return (
                            DataMachines(newState, machines: machines.machines),
                            inputs.map { .int($0) }
                    )
                }
            }
        }
    }
}
