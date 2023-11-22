//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func reducer(
            _ initial: @escaping @autoclosure () -> Output,
            function: @escaping (Output, Input) -> Output?
    ) -> Machine<Input, Output> {
        Machine<Input, Output> { _ in
            Feature<Void, Void, Input, Output>.classic(DataMachines(initial())) { machines, event in
                switch event {
                case .int:
                    return (machines, [], false)
                case .ext(let trigger):
                    if let result = function(machines.data, trigger) {
                        return (machines, [.ext(result)], false)
                    } else {
                        return (machines, [], false)
                    }
                }
            }
        }
    }
}
