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
                                    return ClassicFeatureResult(machines, effects: .int(input))
                                case .back(let output):
                                    return ClassicFeatureResult(machines, effects: .ext(output))
                                }
                            case .int(let output):
                                return ClassicFeatureResult(machines, effects: .ext(output))
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
                        Feature.classic(DataMachines(state, machines: self)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                let (newState, redirectResult) = function(machines.data, input)

                                switch redirectResult {
                                case .prop:
                                    return ClassicFeatureResult(DataMachines(newState, machines: machines.machines), effects: .int(input))
                                case .back(let output):
                                    return ClassicFeatureResult(DataMachines(newState, machines: machines.machines), effects: .ext(output))
                                }
                            case .int(let output):
                                return ClassicFeatureResult(machines, effects: .ext(output))
                            }
                        }
                )
        )
    }
}