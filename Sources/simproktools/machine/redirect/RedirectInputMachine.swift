//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectInput(
            _ function: @escaping (Input) -> Output?
    ) -> Machine<Input, Output> {
        Machine {
            Feature.classic(SetOfMachines(self)) { machines, trigger in
                switch trigger {
                case .ext(let input):
                    if let output = function(input) {
                        return (machines, [.ext(output)], false)
                    } else {
                        return (machines, [.int(input)], false)
                    }
                case .int(let output):
                    return (machines, [.ext(output)], false)
                }
            }
        }
    }

    func redirectInput<State>(
            with state: @escaping @autoclosure () -> State,
            _ function: @escaping (State, Input) -> (newState: State, output: Output?)
    ) -> Machine<Input, Output> {
        Machine {
            Feature.classic(DataMachines(state(), machines: self)) { machines, trigger in
                switch trigger {
                case .ext(let input):
                    let (newState, redirectResult) = function(machines.data, input)
                    if let output = redirectResult {
                        return (DataMachines(newState, machines: machines.machines), [.ext(output)], false)
                    } else {
                        return (DataMachines(newState, machines: machines.machines), [.int(input)], false)
                    }
                case .int(let output):
                    return (machines, [.ext(output)], false)
                }
            }
        }
    }
}
