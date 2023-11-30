//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectOutput(
        _ function: @escaping (Output, (Loggable) -> Void) -> Input?
    ) -> Machine<Input, Output> {
        Machine { machineId in
            Feature.classic(SetOfMachines(self)) { extras, trigger in
                switch trigger {
                case .ext(let input):
                    return (extras.machines, [.int(input)])
                case .int(let output):
                    if let input = function(output, extras.logger) {
                        return (extras.machines, [.int(input)])
                    } else {
                        return (extras.machines, [.ext(output)])
                    }
                }
            }
        }
    }

    func redirectInput<State>(
        with state: @escaping @autoclosure () -> State,
        _ function: @escaping (State, Output, (Loggable) -> Void) -> (newState: State, input: Input?)
    ) -> Machine<Input, Output> {
        Machine { machineId in
            Feature.classic(DataMachines(state(), machines: self)) { extras, trigger in
                switch trigger {
                case .int(let output):
                    let (newState, redirectResult) = function(extras.machines.data, output, extras.logger)
                    if let input = redirectResult {
                        return (DataMachines(newState, machines: extras.machines.machines), [.int(input)])
                    } else {
                        return (DataMachines(newState, machines: extras.machines.machines), [.ext(output)])
                    }
                case .ext(let input):
                    return (extras.machines, [.int(input)])
                }
            }
        }
    }
}
