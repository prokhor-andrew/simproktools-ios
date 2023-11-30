//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokmachine
import simprokstate


public extension Story {
    
    func doOn(function: @escaping @Sendable (StoryExtras, Event) -> Void) -> Story<Event> {
        Story { extras, event in
            function(extras, event)
            if let newStory = transit(event, extras.machineId, extras.logger) {
                return newStory.doOn(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOn(function: @escaping @Sendable (StoryExtras, Event, Bool) -> Void) -> Story<Event> {
        Story { extras, event in
            if let newStory = transit(event, extras.machineId, extras.logger) {
                function(extras, event, false)
                return newStory.doOn(function: function)
            } else {
                function(extras, event, true)
                return nil
            }
        }
    }
    
    func doOnEffect(function: @escaping @Sendable (StoryExtras, Event) -> Void) -> Story<Event> {
        Story { extras, event in
            if let newStory = transit(event, extras.machineId, extras.logger) {
                function(extras, event)
                return newStory.doOnEffect(function: function)
            } else {
                return nil
            }
        }
    }
    
    func doOnGuard(function: @escaping @Sendable (StoryExtras, Event) -> Void) -> Story<Event> {
        Story { extras, event in
            if let newStory = transit(event, extras.machineId, extras.logger) {
                return newStory.doOnGuard(function: function)
            } else {
                function(extras, event)
                return nil
            }
        }
    }
}
