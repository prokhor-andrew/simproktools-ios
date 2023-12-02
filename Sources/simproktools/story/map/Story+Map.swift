//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    func map<REvent>(
        _ function: @escaping (StoryExtras, REvent) -> Event?
    ) -> Story<REvent> {
        map(with: Void()) { extras, state, event in
            if let result = function(extras, event) {
                return (state, result)
            } else {
                return nil
            }
        }
    }

    func map<State, REvent>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (StoryExtras, State, REvent) -> (newState: State, event: Event?)?
    ) -> Story<REvent> {
        Story<REvent> { extras, event in
            if let tuple = function(extras, state(), event) {
                let newState = tuple.0
                if let mapped = tuple.1, let new = transit(mapped, extras.machineId, extras.logger) {
                    return new.map(with: newState, function: function)
                } else {
                    return map(with: newState, function: function)
                }
            } else {
                return nil
            }
        }
    }
}
