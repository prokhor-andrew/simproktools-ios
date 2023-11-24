//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectOutput(
            _ function: @escaping (Output) -> Input?
    ) -> Machine<Input, Output> {
        Machine { _ in
            Feature.classic(SetOfMachines(self)) { machines, trigger in
                switch trigger {
                case .ext(let input):
                    return (machines, [.int(input)])
                case .int(let output):
                    if let input = function(output) {
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
            _ function: @escaping (State, Output) -> (newState: State, input: Input?)
    ) -> Machine<Input, Output> {
        Machine { _ in
            Feature.classic(DataMachines(state(), machines: self)) { machines, trigger in
                switch trigger {
                case .int(let output):
                    let (newState, redirectResult) = function(machines.data, output)
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
