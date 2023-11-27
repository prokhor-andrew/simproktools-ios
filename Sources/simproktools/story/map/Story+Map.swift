//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    func map<REvent>(
        _ function: @escaping (REvent, (String) -> Void) -> Event?
    ) -> Story<REvent> {
        map(with: Void()) { state, event, logger in
            if let result = function(event, logger) {
                return (state, result)
            } else {
                return nil
            }
        }
    }

    func map<State, REvent>(
        with state: State,
        function: @escaping (State, REvent, (String) -> Void) -> (newState: State, event: Event?)?
    ) -> Story<REvent> {
        Story<REvent> {
            if let tuple = function(state, $0, $1) {
                let newState = tuple.0
                if let mapped = tuple.1, let new = transit(mapped, $1) {
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
