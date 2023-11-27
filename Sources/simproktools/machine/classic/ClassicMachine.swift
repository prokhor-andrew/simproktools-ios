//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func classic<State>(
        initial: @escaping @autoclosure () -> State,
        function: @escaping (State, Input, (String) -> Void) -> (newState: State, outputs: [Output])
    ) -> Machine<Input, Output> {
        Machine<Input, Output> {
            Feature<Void, Void, Input, Output>.classic(DataMachines(initial())) { machines, event, logger in
                switch event {
                case .int:
                    return (machines, [])
                case .ext(let trigger):
                    let (newState, effects) = function(machines.data, trigger, logger)
                    return (DataMachines(newState), effects.map { .ext($0) })
                }
            }
        }
    }
}
