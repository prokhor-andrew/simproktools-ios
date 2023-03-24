//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func classic<State>(
            initialState: State,
            initialOutputs: [Output] = [],
            function: @escaping BiMapper<State, Input, (newState: State, outputs: [Output])>
    ) -> Machine<Input, Output> {
        Machine<Input, Output>(
                FeatureTransition(
                        Feature<Void, Void, Input, Output>.classic(DataMachines(initialState)) { machines, event in
                            switch event {
                            case .int:
                                return (machines, [], false)
                            case .ext(let trigger):
                                let (newState, effects) = function(machines.data, trigger)
                                return (DataMachines(newState), effects.map { .ext($0) }, false)
                            }
                        },
                        effects: initialOutputs.map {
                            .ext($0)
                        }
                )
        )
    }
}
