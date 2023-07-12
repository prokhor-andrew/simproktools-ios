//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    func map<REvent>(
            _ function: @escaping (REvent) -> Event?
    ) -> Story<REvent> {
        map(with: Void()) { state, event in
            if let result = function(event) {
                return (state, result)
            } else {
                return nil
            }
        }
    }

    func map<State, REvent>(
            with state: State,
            function: @escaping (State, REvent) -> (newState: State, event: Event?)?
    ) -> Story<REvent> {
        guard let transit else {
            return .finale()
        }

        return Story<REvent>.create {
            if let tuple = function(state, $0) {
                let newState = tuple.0
                if let mapped = tuple.1, let new = transit(mapped) {
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
