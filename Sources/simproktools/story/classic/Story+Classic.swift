//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func classic<State>(
        _ initial: State,
        function: @escaping (State, Event) -> State?
    ) -> Story<Event> {
        Story {
            if let new = function(initial, $0) {
                return classic(new, function: function)
            } else {
                return nil
            }
        }
    }
}

