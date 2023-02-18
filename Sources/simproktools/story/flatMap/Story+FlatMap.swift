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
        guard let transit else {
            return initial ?? .finale()
        }

        let main = Story<Event>.create { event in
            if let new = transit(event) {
                let secondary = function(initial, event)

                return new.flatMap(secondary, function: function)
            } else {
                return nil
            }
        }

        if let initial {
            return main.and(initial)
        } else {
            return main
        }
    }
}