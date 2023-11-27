//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectInput(
        _ function: @escaping (Input, (String) -> Void) -> Output?
    ) -> Machine<Input, Output> {
        Machine {
            Feature.classic(SetOfMachines(self)) { machines, trigger, logger in
                switch trigger {
                case .ext(let input):
                    if let output = function(input, logger) {
                        return (machines, [.ext(output)])
                    } else {
                        return (machines, [.int(input)])
                    }
                case .int(let output):
                    return (machines, [.ext(output)])
                }
            }
        }
    }

    func redirectInput<State>(
        with state: @escaping @autoclosure () -> State,
        _ function: @escaping (State, Input, (String) -> Void) -> (newState: State, output: Output?)
    ) -> Machine<Input, Output> {
        Machine { 
            Feature.classic(DataMachines(state(), machines: self)) { machines, trigger, logger in
                switch trigger {
                case .ext(let input):
                    let (newState, redirectResult) = function(machines.data, input, logger)
                    if let output = redirectResult {
                        return (DataMachines(newState, machines: machines.machines), [.ext(output)])
                    } else {
                        return (DataMachines(newState, machines: machines.machines), [.int(input)])
                    }
                case .int(let output):
                    return (machines, [.ext(output)])
                }
            }
        }
    }
}
