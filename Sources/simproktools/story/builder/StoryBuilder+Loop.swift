//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate



public extension StoryBuilder {
    
    func loop(_ function: @escaping (Event) -> Bool) -> StoryBuilder<Event> {
        handle { state in
            func provide() -> Story<Event> {
                Story.create {
                    if function($0) {
                        return state
                    } else {
                        return provide()
                    }
                }
            }
            
            return provide()
        }
    }
}


public extension StoryBuilder where Event: Equatable {
    
    func loop(is event: Event) -> StoryBuilder<Event> {
        loop {
            event == $0
        }
    }

    func loop(not event: Event) -> StoryBuilder<Event> {
        loop {
            event != $0
        }
    }
}
