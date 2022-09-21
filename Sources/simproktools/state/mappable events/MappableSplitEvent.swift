//
//  MappableSplitEvent.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine



public extension State {

    static func split(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event>]>) -> State<Event> {
        State<Event>.split(states().map { $0.state })
    }
}

public func split<Event>(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event>]>) -> State<Event> {
    State<Event>.split(states())
}


public extension State where Event: CoreEvent {
    
    func or<T: CoreEvent>(_ state: @autoclosure @escaping Supplier<State<T>>) -> State<Event.Event> where T.Event == Event.Event {
        State<Event.Event>.split([.wrap(self), .wrap(state())])
    }
    
    func or(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event.Event>]>) -> State<Event.Event> {
        State<Event.Event>.split(states().copy(add: .wrap(self)))
    }
    
    func or<E>(_ state: @autoclosure @escaping Supplier<State<E>>) -> State<E> where Event.Event == E {
        State<E>.split([
            StateWrapper(self).state,
            state()
        ])
    }
    
    func or<E>(_ states: @autoclosure @escaping Supplier<[State<E>]>) -> State<E> where Event.Event == E {
        State<E>.split(states().copy(add: StateWrapper(self).state))
    }
}



public extension State {
    
    func or<C: CoreEvent>(_ state: @autoclosure @escaping Supplier<State<C>>) -> State<Event> where C.Event == Event {
        state().or(self)
    }
    
    
    func or(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event>]>) -> State<Event> {
        State<Event>.split(states()).or(self)
    }
}
