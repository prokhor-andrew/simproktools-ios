//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func reducer(
        _ initial: @escaping @autoclosure () -> Output,
        function: @escaping (Output, Input, (String) -> Void) -> Output?
    ) -> Machine<Input, Output> {
        Machine<Input, Output> { 
            Feature<Void, Void, Input, Output>.classic(DataMachines(initial())) { machines, event, logger in
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
