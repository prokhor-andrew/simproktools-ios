//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokstate


public extension Story {
    
    func doOn(function: @escaping @Sendable (Event) -> Void) -> Story<Event> {
        Story { event in
            function(event)
            if let newStory = transit(event) {
                return newStory.doOn(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOn(function: @escaping @Sendable (Event, Bool) -> Void) -> Story<Event> {
        Story { event in
            if let newStory = transit(event) {
                function(event, false)
                return newStory.doOn(function: function)
            } else {
                function(event, true)
                return nil
            }
        }
    }
    
    func doOnEffect(function: @escaping @Sendable (Event) -> Void) -> Story<Event> {
        Story { event in
            if let newStory = transit(event) {
                function(event)
                return newStory.doOnEffect(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOnGuard(function: @escaping @Sendable (Event) -> Void) -> Story<Event> {
        Story { event in
            if let newStory = transit(event) {
                return newStory.doOnGuard(function: function)
            } else {
                function(event)
                return nil
            }
        }
    }
}
