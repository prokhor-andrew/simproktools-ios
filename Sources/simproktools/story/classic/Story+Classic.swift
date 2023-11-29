//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func classic<State>(
        _ initial: @autoclosure @escaping () -> State,
        function: @escaping (State, Event, (Loggable) -> Void) -> State?
    ) -> Story<Event> {
        Story { extras, event in
            if let new = function(initial(), event, extras.logger) {
                return classic(new, function: function)
            } else {
                return nil
            }
        }
    }
}

