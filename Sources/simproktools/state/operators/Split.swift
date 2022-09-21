//
//  Split.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func split<Event>(_ states: @autoclosure @escaping Supplier<[State<Event>]>) -> State<Event> {
    State<Event>.split(states())
}

public extension State {
    
    static func split(
        _ states: @autoclosure @escaping Supplier<[State<Event>]>
    ) -> State<Event> {
        State<Event> { event in
            for state in states() {
                let result = state.transit(event)
                switch result {
                case .skip:
                    continue
                case .set(let new):
                    return .set(new)
                }
            }
            return .skip
        }
    }
    
    func or(_ state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event> {
        State<Event>.split([self, state()])
    }
    
    func or(_ states: @autoclosure @escaping Supplier<[State<Event>]>) -> State<Event> {
        State<Event>.split(states().copy(add: self))
    }
}

public extension StateBuilder {
    
    func split(_ states: @autoclosure @escaping Supplier<[State<Event>]>) -> State<Event> {
        link(to: State.split(states()))
    }
}
