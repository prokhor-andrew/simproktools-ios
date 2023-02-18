//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    // isFinaleChecked added to remove unnecessary loops
    private static func merge(isFinaleChecked: Bool, stories: Set<Story<Event>>) -> Story<Event> {
        if !isFinaleChecked {
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
        }

        return Story.create { event in
            var isFinale = true

            let mapped = Set(stories.map { story in
                if let transit = story.transit {
                    isFinale = false
                    if let new = transit(event) {
                        return new
                    } else {
                        return story
                    }
                } else {
                    return story
                }
            })


            if isFinale {
                return .finale()
            } else {
                return merge(isFinaleChecked: true, stories: mapped)
            }
        }
    }

    static func merge(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        merge(isFinaleChecked: false, stories: stories)
    }

    static func merge(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        merge(Set(stories))
    }

    func and(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        .merge(stories.union([self]))
    }

    func and(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        and(Set(stories))
    }
}