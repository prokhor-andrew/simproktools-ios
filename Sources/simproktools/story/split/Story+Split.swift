//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func split(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        func isFinale() -> Bool {
            for story in stories {
                if !story.isFinale {
                    return false
                }
            }

            return true
        }

        if isFinale() {
            return .finale()
        }

        return Story.create {
            for story in stories {
                if let transit = story.transit, let result = transit($0) {
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