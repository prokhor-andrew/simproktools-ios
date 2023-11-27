//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func reducer(
        _ initial: @escaping @autoclosure () -> Output,
        function: @escaping (Output, Input, (Message) -> Void) -> Output?
    ) -> Machine<Input, Output, Message> {
        Machine<Input, Output, Message> {
            Feature<Void, Void, Input, Output, Message>.classic(DataMachines(initial())) { machines, event, logger in
                switch event {
                case .int:
                    return (machines, [])
                case .ext(let trigger):
                    if let result = function(machines.data, trigger, logger) {
                        return (machines, [.ext(result)])
                    } else {
                        return (machines, [])
                    }
                }
            }
        }
    }
}
