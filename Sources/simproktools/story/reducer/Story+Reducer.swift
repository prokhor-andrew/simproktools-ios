//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func reducer<State>(
            _ initial: State,
            function: @escaping BiMapper<State, Event, State?>
    ) -> Story<Event> {
        Story {
            if let new = function(initial, $0) {
                return reducer(new, function: function)
            } else {
                return nil
            }
        }
    }
}