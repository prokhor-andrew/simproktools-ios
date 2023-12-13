//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func classic<State>(
        _ initial: @escaping @autoclosure () -> State,
        function: @escaping (State, Input, String, MachineLogger) -> (newState: State, outputs: [Output])
    ) -> Machine<Input, Output> {
        Machine<Input, Output> { machineId in
            Feature<Void, Void, Input, Output>.classic(DataMachines(initial())) { extras, event in
                switch event {
                case .int:
                    return (extras.machines, [])
                case .ext(let trigger):
                    let (newState, effects) = function(extras.machines.data, trigger, machineId, extras.logger)
                    return (DataMachines(newState), effects.map { .ext($0) })
                }
            }
        }
    }
}
