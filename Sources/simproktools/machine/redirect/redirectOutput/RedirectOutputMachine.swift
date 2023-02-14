//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func redirectOutput(
            _ function: @escaping Mapper<Output, RedirectResult<Input>>
    ) -> Machine<Input, Output> {
        Machine(
                FeatureTransition(
                        Feature.classic(SetOfMachines(self)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                return ClassicFeatureResult(machines, effects: .int(input))
                            case .int(let output):
                                switch function(output) {
                                case .prop:
                                    return ClassicFeatureResult(machines, effects: .ext(output))
                                case .back(let input):
                                    return ClassicFeatureResult(machines, effects: .int(input))
                                }
                            }
                        }
                )
        )
    }

    func redirectInput<State>(
            with state: State,
            _ function: @escaping BiMapper<State, Output, (State, redirect: RedirectResult<Input>)>
    ) -> Machine<Input, Output> {
        Machine(
                FeatureTransition(
                        Feature.classic(DataMachines(state, machines: self)) { machines, trigger in
                            switch trigger {
                            case .int(let output):
                                let (newState, redirectResult) = function(machines.data, output)

                                switch redirectResult {
                                case .prop:
                                    return ClassicFeatureResult(DataMachines(newState, machines: machines.machines), effects: .ext(output))
                                case .back(let input):
                                    return ClassicFeatureResult(DataMachines(newState, machines: machines.machines), effects: .int(input))
                                }
                            case .ext(let input):
                                return ClassicFeatureResult(machines, effects: .int(input))
                            }
                        }
                )
        )
    }
}