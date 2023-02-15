//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {
    static func merge(
            _ stories: [Story<Event>]
    ) -> Story<Event> {
        Story { event in
            var skippable = true
            let new: [Story<Event>] = stories.enumerated().map { index, story in
                if let new = story.transit(event) {
                    skippable = false
                    return new
                } else {
                    return story
                }
            }

            return skippable ? nil : merge(new)
        }
    }

    static func merge(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        merge(stories)
    }

    func and(
            _ stories: [Story<Event>]
    ) -> Story<Event> {
        .merge([self] + stories)
    }

    func and(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        and(stories)
    }
}