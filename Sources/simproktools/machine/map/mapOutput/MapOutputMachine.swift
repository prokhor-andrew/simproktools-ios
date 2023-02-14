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
                                return ClassicFeatureResult(machines, effects: .int(input))
                            case .int(let output):
                                return ClassicFeatureResult(machines, effects: function(output).map {
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
                        Feature.classic(DataMachines(state, machines: self)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                return ClassicFeatureResult(
                                        machines,
                                        effects: .int(input)
                                )
                            case .int(let output):
                                let mapped = function(state, output)
                                return ClassicFeatureResult(
                                        DataMachines(mapped.state, machines: machines.machines),
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