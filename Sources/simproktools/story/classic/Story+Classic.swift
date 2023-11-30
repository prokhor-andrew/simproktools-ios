//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func classic<State>(
        _ initial: @autoclosure @escaping () -> State,
        function: @escaping (StoryExtras, State, Event) -> State?
    ) -> Story<Event> {
        Story { extras, event in
            if let new = function(extras, initial(), event) {
                return classic(new, function: function)
            } else {
                return nil
            }
        }
    }
}

