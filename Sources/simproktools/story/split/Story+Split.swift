//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func split(
            _ stories: [Story<Event>]
    ) -> Story<Event> {
        Story { event in
            for story in stories {
                if let result = story.transit(event) {
                    return result
                } else {
                    continue
                }
            }
            return nil
        }
    }

    static func split(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        split(stories)
    }

    func or(
            _ stories: [Story<Event>]
    ) -> Story<Event> {
        .split([self] + stories)
    }

    func or(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        or(stories)
    }
}