//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func reduce<State>(
            _ initial: State,
            function: @escaping BiMapper<State, Event, State?>
    ) -> Story<Event> {
        Story { event in
            if let new = function(initial, event) {
                return reduce(new, function: function)
            } else {
                return nil
            }
        }
    }
}