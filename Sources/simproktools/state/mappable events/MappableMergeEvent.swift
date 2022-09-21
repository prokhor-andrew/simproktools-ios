//
//  MappableMergeEvent.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public extension State {

    static func merge(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event>]>) -> State<Event> {
        State<Event>.merge(states().map { $0.state })
    }
}

public func merge<Event>(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event>]>) -> State<Event> {
    State<Event>.merge(states())
}


public extension State where Event: CoreEvent {
    
    func and<T: CoreEvent>(_ state: @autoclosure @escaping Supplier<State<T>>) -> State<Event.Event> where T.Event == Event.Event {
        State<Event.Event>.merge([.wrap(self), .wrap(state())])
    }
    
    func and(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event.Event>]>) -> State<Event.Event> {
        State<Event.Event>.merge(states().copy(add: .wrap(self)))
    }
    
    func and<E>(_ state: @autoclosure @escaping Supplier<State<E>>) -> State<E> where Event.Event == E {
        State<E>.merge([
            StateWrapper(self).state,
            state()
        ])
    }
    
    func and<E>(_ states: @autoclosure @escaping Supplier<[State<E>]>) -> State<E> where Event.Event == E {
        State<E>.merge(states().copy(add: StateWrapper(self).state))
    }
}



public extension State {
    
    func and<C: CoreEvent>(_ state: @autoclosure @escaping Supplier<State<C>>) -> State<Event> where C.Event == Event {
        state().and(self)
    }
    
    
    func and(_ states: @autoclosure @escaping Supplier<[StateWrapper<Event>]>) -> State<Event> {
        State<Event>.merge(states()).and(self)
    }
}
