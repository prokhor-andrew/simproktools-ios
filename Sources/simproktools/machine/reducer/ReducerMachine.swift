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
                        Feature<Void, Void, Input, Output>.classic(initial, machines: EmptyMachines()) { payload, machines, event in
                            switch event {
                            case .int:
                                return ClassicResultWithPayload(payload, machines: machines)
                            case .ext(let trigger):
                                if let result = function(payload, trigger) {
                                    return ClassicResultWithPayload(result, machines: machines, effects: .ext(result))
                                } else {
                                    return ClassicResultWithPayload(payload, machines: machines)
                                }
                            }
                        },
                        effects: sendInitial ? [.ext(initial)] : []
                )
        )
    }
}
