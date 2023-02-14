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
        Story {
            if let new = transit($0) {
                if let sub = function(initial, $0) {
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