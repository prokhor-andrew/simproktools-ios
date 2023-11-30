//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func split(
        _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        Story { extras, event in
            for story in stories {
                if let result = story.transit(event, extras.machineId, extras.logger) {
                    return result
                }
            }
            return nil
        }
    }

    static func split(
        _ stories: Story<Event>...
    ) -> Story<Event> {
        split(Set(stories))
    }

    func or(
        _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        .split(stories.union([self]))
    }

    func or(
        _ stories: Story<Event>...
    ) -> Story<Event> {
        or(Set(stories))
    }
}
