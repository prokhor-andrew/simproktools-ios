//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    // isFinaleChecked added to remove unnecessary loops
    private static func mergeFinaleWhenAll(isFinaleChecked: Bool, stories: Set<Story<Event>>) -> Story<Event> {
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
                    if let new = transit(event) {
                        if !new.isFinale {
                            isFinale = false
                        }
                        return new
                    } else {
                        isFinale = false
                        return story
                    }
                } else {
                    return story
                }
            })


            if isFinale {
                return .finale()
            } else {
                return mergeFinaleWhenAll(isFinaleChecked: true, stories: mapped)
            }
        }
    }

    static func mergeFinaleWhenAll(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        mergeFinaleWhenAll(isFinaleChecked: false, stories: stories)
    }

    static func mergeFinaleWhenAll(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        mergeFinaleWhenAll(Set(stories))
    }

    func andFinaleWhenAll(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        .mergeFinaleWhenAll(stories.union([self]))
    }

    func andFinaleWhenAll(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        andFinaleWhenAll(Set(stories))
    }
}
