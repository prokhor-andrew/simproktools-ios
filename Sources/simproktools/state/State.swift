//
//  State.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public struct State<Event> {
    
    public let transit: Mapper<Event, Transition<State<Event>>>
 
    public init(transit: @escaping Mapper<Event, Transition<State<Event>>>) {
        self.transit = transit
    }
    
    public func isExpecting(event: Event) -> Bool {
        switch transit(event) {
        case .set:
            return true
        case .skip:
            return false
        }
    }
    
    public func isExpecting(any events: Event...) -> Bool {
        isExpecting(any: events)
    }
    
    public func isExpecting(any events: [Event]) -> Bool {
        if events.isEmpty {
            return false
        }
        for event in events {
            switch transit(event) {
            case .set:
                return true
            case .skip:
                break
            }
        }
        return false
    }
    
    public func isExpecting(all events: Event...) -> Bool {
        isExpecting(all: events)
    }
    
    public func isExpecting(all events: [Event]) -> Bool {
        if events.isEmpty {
            return false
        }
        for event in events {
            switch transit(event) {
            case .skip:
                return false
            case .set:
                break
            }
        }
        return true
    }
}
