//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    func mapOutput<ROutput>(_ function: @escaping (Output, (Message) -> Void) -> [ROutput]) -> Machine<Input, ROutput, Message> {
        mapOutput(with: Void(), function: { ($0, function($1, $2)) })
    }

    func mapOutput<State, ROutput>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Output, (Message) -> Void) -> (newState: State, outputs: [ROutput])
    ) -> Machine<Input, ROutput, Message> {
        biMap(with: state, mapInput: { state, input, logger in (state, [input]) }, mapOutput: function)
    }
}
