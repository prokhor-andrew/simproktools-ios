//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate


public extension Story {
    
    // isFinaleChecked added to remove unnecessary loops
    private static func mergeFinaleWhenOne(
            isFinaleChecked: Bool,
            stories: Set<Story<Event>>
    ) -> Story<Event> {
        if !isFinaleChecked {
            func isFinale() -> Bool {
                for story in stories {
                    if story.isFinale {
                        return true
                    }
                }

                return false
            }

            if isFinale() {
                return .finale()
            }
        }

        return Story.create { trigger in
            var isFinale = false

            let mapped = Set(stories.map { story in
                if let transit = story.transit {
                    if let new = transit(trigger) {
                        if new.isFinale {
                            isFinale = true
                        }
                        
                        return new
                    } else {
                        return story
                    }
                } else {
                    isFinale = true
                    return story
                }
            })
            
            
            if isFinale {
                return .finale()
            } else {
                return mergeFinaleWhenOne(isFinaleChecked: true, stories: mapped)
            }
        }
    }

    static func mergeFinaleWhenOne(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        mergeFinaleWhenOne(isFinaleChecked: false, stories: stories)
    }
    
    static func mergeFinaleWhenOne(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        mergeFinaleWhenOne(Set(stories))
    }

    func andFinaleWhenOne(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        .mergeFinaleWhenOne(stories.union([self]))
    }

    func andFinaleWhenOne(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        andFinaleWhenOne(Set(stories))
    }
}
