//
// Created by Andriy Prokhorenko on 12.02.2023.
//

import simprokmachine
import simprokstate

public struct StoryBuilder<Event> {

    private let storySupplier: Mapper<Mapper<Event, Story<Event>?>, Story<Event>>

    public init() {
        storySupplier = Story.init
    }

    private init(_ storySupplier: @escaping Mapper<Mapper<Event, Story<Event>?>, Story<Event>>) {
        self.storySupplier = storySupplier
    }

    public func when(_ function: @escaping Mapper<Event, Bool>) -> StoryBuilder<Event> {
        StoryBuilder { mapper in
            storySupplier {
                if function($0) {
                    return Story(transit: mapper)
                } else {
                    return nil
                }
            }
        }
    }

    public func when(is event: Event) -> StoryBuilder<Event> where Event: Equatable {
        when {
            event == $0
        }
    }

    public func when(not event: Event) -> StoryBuilder<Event> where Event: Equatable {
        when {
            event != $0
        }
    }

    public func `while`(_ function: @escaping Mapper<Event, Bool>) -> StoryBuilder<Event> {
        StoryBuilder { mapper in

            func story() -> Story<Event> {
                storySupplier {
                    if function($0) {
                        return story()
                    } else {
                        return Story(transit: mapper)
                    }
                }
            }

            return story()
        }
    }

    public func `while`(is event: Event) -> StoryBuilder<Event> where Event: Equatable {
        `while` { event == $0 }
    }

    public func `while`(not event: Event) -> StoryBuilder<Event> where Event: Equatable {
        `while` { event != $0 }
    }

    public func until(_ function: @escaping Mapper<Event, Bool>) -> StoryBuilder<Event> {
        StoryBuilder { mapper in
            func story() -> Story<Event> {
                storySupplier {
                    if function($0) {
                        return Story(transit: mapper)
                    } else {
                        return story()
                    }
                }
            }

            return story()
        }
    }

    public func until(is event: Event) -> StoryBuilder<Event> where Event: Equatable {
        until { $0 == event }
    }

    public func until(not event: Event) -> StoryBuilder<Event> where Event: Equatable {
        until { $0 != event }
    }

    public func then(_ function: @escaping Mapper<Event, Story<Event>?>) -> Story<Event> {
        storySupplier(function)
    }

    public func then(is event: Event, story: @autoclosure @escaping Supplier<Story<Event>>) -> Story<Event> where Event: Equatable {
        then {
            if event == $0 {
                return story()
            } else {
                return nil
            }
        }
    }

    public func then(not event: Event, story: @autoclosure @escaping Supplier<Story<Event>>) -> Story<Event> where Event: Equatable {
        then {
            if event != $0 {
                return story()
            } else {
                return nil
            }
        }
    }
}
