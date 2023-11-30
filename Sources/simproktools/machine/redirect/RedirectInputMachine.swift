//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectInput(
        _ function: @escaping (Input, (Loggable) -> Void) -> Output?
    ) -> Machine<Input, Output> {
        Machine {
            Feature.classic(SetOfMachines(self)) { extras, trigger in
                switch trigger {
                case .ext(let input):
                    if let output = function(input, extras.logger) {
                        return (extras.machines, [.ext(output)])
                    } else {
                        return (extras.machines, [.int(input)])
                    }
                case .int(let output):
                    return (extras.machines, [.ext(output)])
                }
            }
        }
    }

    func redirectInput<State>(
        with state: @escaping @autoclosure () -> State,
        _ function: @escaping (State, Input, (Loggable) -> Void) -> (newState: State, output: Output?)
    ) -> Machine<Input, Output> {
        Machine { 
            Feature.classic(DataMachines(state(), machines: self)) { extras, trigger in
                switch trigger {
                case .ext(let input):
                    let (newState, redirectResult) = function(extras.machines.data, input, extras.logger)
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
