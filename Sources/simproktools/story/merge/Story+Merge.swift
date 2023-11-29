//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 27.10.2023.
//

import simprokstate


public extension Story {

    
    static func merge(
        _ stories: [Story<Event>]
    ) -> Story<Event> {
        Story { extras, event in
            let mapped = stories.map { story in
                if let newStory = story.transit(event, extras.logger) {
                    return newStory
                } else {
                    return story
                }
            }
            
            return merge(mapped)
        }
    }
    
    static func merge(
        _ stories: Story<Event>...
    ) -> Story<Event> {
        merge(stories)
    }
}
