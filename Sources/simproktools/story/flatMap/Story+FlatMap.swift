//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    func flatMap(
            _ initial: Story<Event>? = nil,
            function: @escaping BiMapper<Story<Event>?, Event, Story<Event>?>
    ) -> Story<Event> {
        Story { event in
            if let new = transit(event) {
                if let sub = function(initial, event) {
                    return new.flatMap(sub, function: function)
                } else {
                    return new.flatMap(initial, function: function)
                }
            } else {
                return nil
            }
        }.and(initial ?? .never())
    }
}