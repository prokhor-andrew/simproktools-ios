//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokmachine
import simprokstate


public extension Story {
    
    func doOn(function: @escaping @Sendable (Event, (Loggable) -> Void) -> Void) -> Story<Event> {
        Story { extras, event in
            function(event, extras.logger)
            if let newStory = transit(event, extras.logger) {
                return newStory.doOn(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOn(function: @escaping @Sendable (Event, Bool, (Loggable) -> Void) -> Void) -> Story<Event> {
        Story { extras, event in
            if let newStory = transit(event, extras.logger) {
                function(event, false, extras.logger)
                return newStory.doOn(function: function)
            } else {
                function(event, true, extras.logger)
                return nil
            }
        }
    }
    
    func doOnEffect(function: @escaping @Sendable (Event, (Loggable) -> Void) -> Void) -> Story<Event> {
        Story { extras, event in
            if let newStory = transit(event, extras.logger) {
                function(event, extras.logger)
                return newStory.doOnEffect(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOnGuard(function: @escaping @Sendable (Event, (Loggable) -> Void) -> Void) -> Story<Event> {
        Story { extras, event in
            if let newStory = transit(event, extras.logger) {
                return newStory.doOnGuard(function: function)
            } else {
                function(event, extras.logger)
                return nil
            }
        }
    }
}
