//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    func mapOutput<ROutput>(_ function: @escaping Mapper<Output, [ROutput]>) -> Machine<Input, ROutput> {
        Machine<Input, ROutput>(
                FeatureTransition(
                        Feature.classic(SetOfMachines(self)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                return ClassicResult(machines, effects: .int(input))
                            case .int(let output):
                                return ClassicResult(machines, effects: function(output).map {
                                    .ext($0)
                                })
                            }
                        }
                )
        )
    }

    func mapOutput<State, ROutput>(
            with state: State,
            function: @escaping BiMapper<State, Output, MapWithStateResult<State, ROutput>>
    ) -> Machine<Input, ROutput> {
        Machine<Input, ROutput>(
                FeatureTransition(
                        Feature.classic(state, machines: SetOfMachines(self)) { state, machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                return ClassicResultWithPayload(
                                        state,
                                        machines: machines,
                                        effects: .int(input)
                                )
                            case .int(let output):
                                let mapped = function(state, output)
                                return ClassicResultWithPayload(
                                        mapped.state,
                                        machines: machines,
                                        effects: mapped.events.map {
                                            .ext($0)
                                        }
                                )
                            }
                        }
                )
        )
    }
}