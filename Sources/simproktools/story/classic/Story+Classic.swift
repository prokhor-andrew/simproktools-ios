//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func classic<State>(
            _ initial: State,
            function: @escaping (State, Event) -> ClassicStoryResult<State>
    ) -> Story<Event> {
        Story.create {
            switch function(initial, $0) {
            case .skip:
                return nil
            case .finale:
                return .finale()
            case .next(let new):
                return classic(new, function: function)
            }
        }
    }
    
    static func classic(
        function: @escaping (Event) -> Bool?
    ) -> Story<Event> {
        classic(Void()) { state, trigger in
            if let isFinale = function(trigger) {
                if isFinale {
                    return .finale
                } else {
                    return .next(state)
                }
            } else {
                return .skip
            }
        }
    }
}

