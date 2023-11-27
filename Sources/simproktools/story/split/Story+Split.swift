//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func split(
        _ stories: Set<Story<Event, Message>>
    ) -> Story<Event, Message> {
        Story {
            for story in stories {
                if let result = story.transit($0, $1) {
                    return result
                }
            }
            return nil
        }
    }

    static func split(
        _ stories: Story<Event, Message>...
    ) -> Story<Event, Message> {
        split(Set(stories))
    }

    func or(
        _ stories: Set<Story<Event, Message>>
    ) -> Story<Event, Message> {
        .split(stories.union([self]))
    }

    func or(
        _ stories: Story<Event, Message>...
    ) -> Story<Event, Message> {
        or(Set(stories))
    }
}
