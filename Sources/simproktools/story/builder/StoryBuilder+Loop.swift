//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate
import CasePaths


public extension StoryBuilder {
    
    func loop(_ function: @escaping (Event) -> Bool) -> StoryBuilder<Event> {
        handle { state in
            
            @Sendable
            func provide() -> Story<Event> {
                Story { extras, event in
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
    
    func loop(_ operation: @escaping (Event, Event) -> Bool, _ value: Event) -> StoryBuilder<Event> {
        loop {
            operation($0, value)
        }
    }
    
    
    func loop<T>(_ keyPath: KeyPath<Event, T>, function: @escaping (T) -> Bool) -> StoryBuilder<Event> {
        loop {
            function($0[keyPath: keyPath])
        }
    }
    
    func loop<T>(_ keyPath: KeyPath<Event, T>, _ operation: @escaping (T, T) -> Bool, _ value: T) -> StoryBuilder<Event> {
        loop(keyPath) {
            operation($0, value)
        }
    }
    
    func loop<T: Equatable>(_ keyPath: KeyPath<Event, T>, is value: T) -> StoryBuilder<Event> {
        loop(keyPath, ==, value)
    }
    
    func loop<T: Equatable>(_ keyPath: KeyPath<Event, T>, not value: T) -> StoryBuilder<Event> {
        loop(keyPath, !=, value)
    }
}


public extension StoryBuilder where Event: CasePathable {
    
    func loop<T>(_ casePath: CaseKeyPath<Event, T>, _ function: @escaping (T) -> Bool) -> StoryBuilder<Event> {
        loop {
            if let value = $0[case: casePath] {
                function(value)
            } else {
                false
            }
        }
    }
    
    func loop<T>(_ casePath: CaseKeyPath<Event, T>, _ operation: @escaping (T, T) -> Bool, _ value: T) -> StoryBuilder<Event> {
        loop(casePath) {
            operation($0, value)
        }
    }
    
    func loop<T: Equatable>(_ casePath: CaseKeyPath<Event, T>, is value: T) -> StoryBuilder<Event> {
        loop(casePath, ==, value)
    }
    
    func loop<T: Equatable>(_ casePath: CaseKeyPath<Event, T>, not value: T) -> StoryBuilder<Event> {
        loop(casePath, !=, value)
    }
}


public extension StoryBuilder where Event: Equatable {
    
    func loop(is event: Event) -> StoryBuilder<Event> {
        loop(==, event)
    }

    func loop(not event: Event) -> StoryBuilder<Event> {
        loop(!=, event)
    }
}
