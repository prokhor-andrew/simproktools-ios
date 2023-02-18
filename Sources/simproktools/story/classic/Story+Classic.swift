//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func classic<State>(
            _ initial: State,
            function: @escaping BiMapper<State, Event, State?>
    ) -> Story<Event> {
        Story.create {
            if let new = function(initial, $0) {
                return classic(new, function: function)
            } else {
                return nil
            }
        }
    }
}