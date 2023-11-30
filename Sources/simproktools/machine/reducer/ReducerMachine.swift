//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func reducer(
        _ initial: @escaping @autoclosure () -> Output,
        function: @escaping (Output, Input, (Loggable) -> Void) -> Output?
    ) -> Machine<Input, Output> {
        Machine<Input, Output> { machineId in
            Feature<Void, Void, Input, Output>.classic(DataMachines(initial())) { extras, event in
                switch event {
                case .int:
                    return (extras.machines, [])
                case .ext(let trigger):
                    if let result = function(extras.machines.data, trigger, extras.logger) {
                        return (extras.machines, [.ext(result)])
                    } else {
                        return (extras.machines, [])
                    }
                }
            }
        }
    }
}
