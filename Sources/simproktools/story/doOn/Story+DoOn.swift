//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokstate


public extension Story {
    
    func doOn(function: @escaping @Sendable (Event, (Message) -> Void) -> Void) -> Story<Event, Message> {
        Story { event, logger in
            function(event, logger)
            if let newStory = transit(event, logger) {
                return newStory.doOn(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOn(function: @escaping @Sendable (Event, Bool, (Message) -> Void) -> Void) -> Story<Event, Message> {
        Story { event, logger in
            if let newStory = transit(event, logger) {
                function(event, false, logger)
                return newStory.doOn(function: function)
            } else {
                function(event, true, logger)
                return nil
            }
        }
    }
    
    func doOnEffect(function: @escaping @Sendable (Event, (Message) -> Void) -> Void) -> Story<Event, Message> {
        Story { event, logger in
            if let newStory = transit(event, logger) {
                function(event, logger)
                return newStory.doOnEffect(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOnGuard(function: @escaping @Sendable (Event, (Message) -> Void) -> Void) -> Story<Event, Message> {
        Story { event, logger in
            if let newStory = transit(event, logger) {
                return newStory.doOnGuard(function: function)
            } else {
                function(event, logger)
                return nil
            }
        }
    }
}
