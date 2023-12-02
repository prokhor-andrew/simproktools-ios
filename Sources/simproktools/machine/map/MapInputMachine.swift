//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func mapInput<RInput>(_ function: @escaping (RInput, String, (Loggable) -> Void) -> [Input]) -> Machine<RInput, Output> {
        mapInput(with: Void()) { state, input, id, logger in
            (state, function(input, id, logger))
        }
    }

    func mapInput<State, RInput>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, RInput, String, (Loggable) -> Void) -> (newState: State, inputs: [Input])
    ) -> Machine<RInput, Output> {
        biMap(with: state, mapInput: function, mapOutput: { state, output, id, logger in (state, [output]) })
    }
}
