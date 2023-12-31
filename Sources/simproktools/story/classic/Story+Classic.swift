//
// Created by Andriy Prokhorenko on 11.02.2023.
//


import simprokstate

public extension Story {

    static func classic(
        _ initial: Payload,
        function: @escaping (StoryExtras<Payload, Loggable>, Event) -> Payload?
    ) -> Story<Payload, Event, Loggable> {
        Story(payload: initial) { extras, event in
            if let new = function(extras, event) {
                return classic(new, function: function)
            } else {
                return nil
            }
        }
    }
}

