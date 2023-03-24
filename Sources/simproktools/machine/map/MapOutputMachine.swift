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
                                return (machines, [.int(input)], false)
                            case .int(let output):
                                return (machines, function(output).map { .ext($0) }, false)
                            }
                        }
                )
        )
    }

    func mapOutput<State, ROutput>(
            with state: State,
            function: @escaping BiMapper<State, Output, (newState: State, outputs: [ROutput])>
    ) -> Machine<Input, ROutput> {
        Machine<Input, ROutput>(
                FeatureTransition(
                        Feature.classic(DataMachines(state, machines: self)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                return (machines, [.int(input)], false)
                            case .int(let output):
                                let (newState, outputs) = function(machines.data, output)
                                return (DataMachines(newState, machines: machines.machines), outputs.map { .ext($0) }, false)
                            }
                        }
                )
        )
    }
}
