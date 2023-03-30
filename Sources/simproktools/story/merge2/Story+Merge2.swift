//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate


public extension Story {
    
    // isFinaleChecked added to remove unnecessary loops
    private static func merge2(
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
                return merge2(isFinaleChecked: true, stories: mapped)
            }
        }
    }

    static func merge2(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        merge2(isFinaleChecked: false, stories: stories)
    }
    
    static func merge2(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        merge2(Set(stories))
    }

    func and2(
            _ stories: Set<Story<Event>>
    ) -> Story<Event> {
        .merge2(stories.union([self]))
    }

    func and2(
            _ stories: Story<Event>...
    ) -> Story<Event> {
        and2(Set(stories))
    }
}
