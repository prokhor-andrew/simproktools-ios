//
//  Merge.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func merge<Event>(
    _ states: @autoclosure @escaping Supplier<[State<Event>]>
) -> State<Event> {
    State<Event>.merge(states())
}


public extension State {
    
    static func merge(
        _ states: @autoclosure @escaping Supplier<[State<Event>]>
    ) -> State<Event> {
        State<Event> { event in
            var skippable = true
            let new: [State<Event>] = states().enumerated().map { index, state in
                switch state.transit(event) {
                case .skip:
                    return state
                case .set(let new):
                    skippable = false
                    return new
                }
            }

            return skippable ? .skip : .set(merge(new))
        }
    }
    
    func and(_ state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event> {
        State<Event>.merge([self, state()])
    }
    
    func and(_ states: @autoclosure @escaping Supplier<[State<Event>]>) -> State<Event> {
        State<Event>.merge(states().copy(add: self))
    }
}


public extension StateBuilder {
    
    func merge(_ states: @autoclosure @escaping Supplier<[State<Event>]>) -> State<Event> {
        link(to: State.merge(states()))
    }
}
