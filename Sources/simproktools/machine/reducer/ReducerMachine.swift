//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func reducer(
            _ initial: Output,
            sendInitial: Bool = false,
            function: @escaping BiMapper<Output, Input, Output?>
    ) -> Machine<Input, Output> {
        Machine<Input, Output>(
                FeatureTransition(
                        Feature<Void, Void, Input, Output>.classic(DataMachines(initial)) { machines, event in
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
                        },
                        effects: sendInitial ? [.ext(initial)] : []
                )
        )
    }
}
