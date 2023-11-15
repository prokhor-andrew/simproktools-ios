//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

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
    
    func when(_ operation: @escaping (Event, Event) -> Bool, _ value: Event) -> StoryBuilder<Event> {
        when {
            operation($0, value)
        }
    }
    
    func when<T>(_ keyPath: KeyPath<Event, T>, function: @escaping (T) -> Bool) -> StoryBuilder<Event> {
        when {
            function($0[keyPath: keyPath])
        }
    }
    
    func when<T>(_ keyPath: KeyPath<Event, T>, _ operation: @escaping (T, T) -> Bool, _ value: T) -> StoryBuilder<Event> {
        when(keyPath) {
            operation($0, value)
        }
    }
    
    func when<T: Equatable>(_ keyPath: KeyPath<Event, T>, is value: T) -> StoryBuilder<Event> {
        when(keyPath, ==, value)
    }
    
    func when<T: Equatable>(_ keyPath: KeyPath<Event, T>, not value: T) -> StoryBuilder<Event> {
        when(keyPath, !=, value)
    }
}

public extension StoryBuilder where Event: Equatable {
        
    func when(is event: Event) -> StoryBuilder<Event> {
        when(==, event)
    }

    func when(not event: Event) -> StoryBuilder<Event> {
        when(!=, event)
    }
}
