//
// Created by Andriy Prokhorenko on 20.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func biMap<RInput, ROutput>(
        mapInput: @escaping (RInput, (Loggable) -> Void) -> [Input],
        mapOutput: @escaping (Output, (Loggable) -> Void) -> [ROutput]
    ) -> Machine<RInput, ROutput> {
        biMap { Void() } mapInput: { state, input, logger in
            (state, mapInput(input, logger))
        } mapOutput: { state, output, logger in
            (state, mapOutput(output, logger))
        }
    }
    
    func biMap<State, RInput, ROutput>(
        with state: @escaping () -> State,
        mapInput: @escaping (State, RInput, (Loggable) -> Void) -> (newState: State, inputs: [Input]),
        mapOutput: @escaping (State, Output, (Loggable) -> Void) -> (newState: State, outputs: [ROutput])
    ) -> Machine<RInput, ROutput> {
        Machine<RInput, ROutput> { machineId in
            Feature.classic(DataMachines(state(), machines: self)) { extras, trigger in
                switch trigger {
                case .int(let output):
                    let (newState, outputs) = mapOutput(extras.machines.data, output, extras.logger)

                    return (
                        DataMachines(newState, machines: extras.machines.machines),
                        outputs.map { .ext($0) }
                    )
                case .ext(let input):
                    let (newState, inputs) = mapInput(extras.machines.data, input, extras.logger)

                    return (
                        DataMachines(newState, machines: extras.machines.machines),
                        inputs.map { .int($0) }
                    )
                }
            }
        }
    }
}
