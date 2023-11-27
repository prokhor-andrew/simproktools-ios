//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func mapInput<RInput>(_ function: @escaping (RInput, (String) -> Void) -> [Input]) -> Machine<RInput, Output> {
        mapInput(with: Void()) { ($0, function($1, $2)) }
    }

    func mapInput<State, RInput>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, RInput, (String) -> Void) -> (newState: State, inputs: [Input])
    ) -> Machine<RInput, Output> {
        biMap(with: state, mapInput: function, mapOutput: { state, output, logger in (state, [output]) })
    }
}
