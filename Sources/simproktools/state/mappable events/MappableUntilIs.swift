//
//  MappableUntilIs.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine



public func until<Event: CoreEvent & Equatable, Event2: CoreEvent>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event2>>
) -> State<Event.Event> where Event.Event == Event2.Event {
    State<Event.Event>.until(is: event(), next: state())
}

public func until<Event: CoreEvent & Equatable>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event.Event> {
    State<Event.Event>.until(is: event(), next: state())
}

public func until<Event: CoreEvent & Equatable>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event.Event>>
) -> State<Event.Event> {
    State<Event.Event>.until(is: event(), next: state())
}

public func until<Event: CoreEvent, Event2: CoreEvent>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event2>>
) -> State<Event.Event> where Event.Event == Event2.Event {
    State<Event.Event>.until(is: condition(), next: state())
}

public func until<Event: CoreEvent>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event.Event> {
    State<Event.Event>.until(is: condition(), next: state())
}

public func until<Event: CoreEvent>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event.Event>>
) -> State<Event.Event> {
    State<Event.Event>.until(is: condition(), next: state())
}


public extension State {
    
    static func until<E1: CoreEvent & Equatable, E2: CoreEvent>(
        is event: @autoclosure @escaping Supplier<E1>,
        next state: @autoclosure @escaping Supplier<State<E2>>
    ) -> State<Event> where E1.Event == Event, E2.Event == Event {
        State<Event>.while(not: event(), next: state())
    }
    
    static func until<E: CoreEvent & Equatable>(
        is event: @autoclosure @escaping Supplier<E>,
        next state: @autoclosure @escaping Supplier<State<E>>
    ) -> State<Event> where E.Event == Event {
        State<Event>.while(not: event(), next: state())
    }
    
    static func until<E: CoreEvent & Equatable>(
        is event: @autoclosure @escaping Supplier<E>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> where E.Event == Event {
        State<Event>.while(not: event(), next: state())
    }
    
    static func until<E1: CoreEvent, E2: CoreEvent>(
        is condition: @autoclosure @escaping Supplier<Condition<E1>>,
        next state: @autoclosure @escaping Supplier<State<E2>>
    ) -> State<Event> where E1.Event == Event, E2.Event == Event {
        State<Event>.while(not: condition(), next: state())
    }
    
    static func until<E: CoreEvent>(
        is condition: @autoclosure @escaping Supplier<Condition<E>>,
        next state: @autoclosure @escaping Supplier<State<E>>
    ) -> State<Event> where E.Event == Event {
        State<Event>.while(not: condition(), next: state())
    }
    
    static func until<E: CoreEvent>(
        is condition: @autoclosure @escaping Supplier<Condition<E>>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> where E.Event == Event {
        State<Event>.while(not: condition(), next: state())
    }
}
