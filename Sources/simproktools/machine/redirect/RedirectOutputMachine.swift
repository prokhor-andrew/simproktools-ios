//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectOutput(
        _ function: @escaping (Output, (Loggable) -> Void) -> Input?
    ) -> Machine<Input, Output> {
        Machine {
            Feature.classic(SetOfMachines(self)) { machines, trigger, logger in
                switch trigger {
                case .ext(let input):
                    return (machines, [.int(input)])
                case .int(let output):
                    if let input = function(output, logger) {
                        return (machines, [.int(input)])
                    } else {
                        return (machines, [.ext(output)])
                    }
                }
            }
        }
    }

    func redirectInput<State>(
        with state: @escaping @autoclosure () -> State,
        _ function: @escaping (State, Output, (Loggable) -> Void) -> (newState: State, input: Input?)
    ) -> Machine<Input, Output> {
        Machine { 
            Feature.classic(DataMachines(state(), machines: self)) { machines, trigger, logger in
                switch trigger {
                case .int(let output):
                    let (newState, redirectResult) = function(machines.data, output, logger)
                    if let input = redirectResult {
                        return (DataMachines(newState, machines: machines.machines), [.int(input)])
                    } else {
                        return (DataMachines(newState, machines: machines.machines), [.ext(output)])
                    }
                case .ext(let input):
                    return (machines, [.int(input)])
                }
            }
        }
    }
}
