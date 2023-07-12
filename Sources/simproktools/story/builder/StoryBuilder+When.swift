//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate



public extension StoryBuilder {
    
    func when(_ function: @escaping (Event) -> Bool) -> StoryBuilder<Event> {
        handle { state in
            Story.create {
                if function($0) {
                    return state
                } else {
                    return nil
                }
            }
        }

    }
}

public extension StoryBuilder where Event: Equatable {
    
    func when(is event: Event) -> StoryBuilder<Event> {
        when {
            event == $0
        }
    }

    func when(not event: Event) -> StoryBuilder<Event> {
        when {
            event != $0
        }
    }
}
