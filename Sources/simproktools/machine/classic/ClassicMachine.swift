//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func classic<State>(
        initial: @escaping @autoclosure () -> State,
        function: @escaping (State, Input, (Message) -> Void) -> (newState: State, outputs: [Output])
    ) -> Machine<Input, Output, Message> {
        Machine<Input, Output, Message> {
            Feature<Void, Void, Input, Output, Message>.classic(DataMachines(initial())) { machines, event, logger in
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
