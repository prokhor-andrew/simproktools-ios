//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectInput(
            _ function: @escaping Mapper<Input, RedirectResult<Output>>
    ) -> Machine<Input, Output> {
        Machine(
                FeatureTransition(
                        Feature.classic(SetOfMachines(self)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                switch function(input) {
                                case .prop:
                                    return ClassicResult(machines, effects: .int(input))
                                case .back(let output):
                                    return ClassicResult(machines, effects: .ext(output))
                                }
                            case .int(let output):
                                return ClassicResult(machines, effects: .ext(output))
                            }
                        }
                )
        )
    }

    func redirectInput<State>(
            with state: State,
            _ function: @escaping BiMapper<State, Input, (State, redirect: RedirectResult<Output>)>
    ) -> Machine<Input, Output> {
        Machine(
                FeatureTransition(
                        Feature.classic(state, machines: SetOfMachines(self)) { payload, machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                let (newState, redirectResult) = function(payload, input)

                                switch redirectResult {
                                case .prop:
                                    return ClassicResultWithPayload(newState, machines: machines, effects: .int(input))
                                case .back(let output):
                                    return ClassicResultWithPayload(newState, machines: machines, effects: .ext(output))
                                }
                            case .int(let output):
                                return ClassicResultWithPayload(payload, machines: machines, effects: .ext(output))
                            }
                        }
                )
        )
    }
}