//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    func mapInput<RInput>(_ function: @escaping (RInput) -> [Input]) -> Machine<RInput, Output> {
        mapInput(with: Void()) { ($0, function($1)) }
    }

    func mapInput<State, RInput>(
            with state: @escaping @autoclosure () -> State,
            function: @escaping (State, RInput) -> (newState: State, inputs: [Input])
    ) -> Machine<RInput, Output> {
        biMap(with: state, mapInput: function, mapOutput: { ($0, [$1]) })
    }
}
