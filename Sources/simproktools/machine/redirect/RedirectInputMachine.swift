//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectInput(
        _ function: @escaping (Input, String, MachineLogger) -> Output?
    ) -> Machine<Input, Output> {
        redirectInput(with: Void()) { state, input, id, logger in
            (state, function(input, id, logger))
        }
    }

    func redirectInput<State>(
        with state: @escaping @autoclosure () -> State,
        _ function: @escaping (State, Input, String, MachineLogger) -> (newState: State, output: Output?)
    ) -> Machine<Input, Output> {
        Machine { machineId in
            Feature.classic(DataMachines(state(), machines: self)) { extras, trigger in
                switch trigger {
                case .ext(let input):
                    let (newState, redirectResult) = function(extras.machines.data, input, machineId, extras.logger)
                    if let output = redirectResult {
                        return (DataMachines(newState, machines: extras.machines.machines), [.ext(output)])
                    } else {
                        return (DataMachines(newState, machines: extras.machines.machines), [.int(input)])
                    }
                case .int(let output):
                    return (extras.machines, [.ext(output)])
                }
            }
        }
    }
}
