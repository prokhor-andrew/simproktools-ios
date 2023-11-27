//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate



public extension StoryBuilder {
    
    func loop(_ function: @escaping (Event) -> Bool) -> StoryBuilder<Event, Message> {
        handle { state in
            
            @Sendable
            func provide() -> Story<Event, Message> {
                Story { event, logger in
                    if function(event) {
                        return state
                    } else {
                        return provide()
                    }
                }
            }
            
            return provide()
        }
    }
    
    func loop(_ operation: @escaping (Event, Event) -> Bool, _ value: Event) -> StoryBuilder<Event, Message> {
        loop {
            operation($0, value)
        }
    }
    
    
    func loop<T>(_ keyPath: KeyPath<Event, T>, function: @escaping (T) -> Bool) -> StoryBuilder<Event, Message> {
        loop {
            function($0[keyPath: keyPath])
        }
    }
    
    func loop<T>(_ keyPath: KeyPath<Event, T>, _ operation: @escaping (T, T) -> Bool, _ value: T) -> StoryBuilder<Event, Message> {
        loop(keyPath) {
            operation($0, value)
        }
    }
    
    func loop<T: Equatable>(_ keyPath: KeyPath<Event, T>, is value: T) -> StoryBuilder<Event, Message> {
        loop(keyPath, ==, value)
    }
    
    func loop<T: Equatable>(_ keyPath: KeyPath<Event, T>, not value: T) -> StoryBuilder<Event, Message> {
        loop(keyPath, !=, value)
    }
}


public extension StoryBuilder where Event: Equatable {
    
    func loop(is event: Event) -> StoryBuilder<Event, Message> {
        loop(==, event)
    }

    func loop(not event: Event) -> StoryBuilder<Event, Message> {
        loop(!=, event)
    }
}
