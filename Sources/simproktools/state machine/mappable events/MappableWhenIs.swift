//
//  MappableWhenIs.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func when<Event: CoreEvent & Equatable, Event2: CoreEvent>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event2>>
) -> State<Event.Event> where Event.Event == Event2.Event {
    State<Event.Event>.when(is: event(), next: state())
}

public func when<Event: CoreEvent & Equatable>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event.Event> {
    State<Event.Event>.when(is: event(), next: state())
}

public func when<Event: CoreEvent & Equatable>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event.Event>>
) -> State<Event.Event> {
    State<Event.Event>.when(is: event(), next: state())
}

public func when<Event: CoreEvent, Event2: CoreEvent>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event2>>
) -> State<Event.Event> where Event.Event == Event2.Event {
    State<Event.Event>.when(is: condition(), next: state())
}

public func when<Event: CoreEvent>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event.Event> {
    State<Event.Event>.when(is: condition(), next: state())
}

public func when<Event: CoreEvent>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event.Event>>
) -> State<Event.Event> {
    State<Event.Event>.when(is: condition(), next: state())
}


public extension State {
    

    static func when<E1: CoreEvent & Equatable, E2: CoreEvent>(
        is event: @autoclosure @escaping Supplier<E1>,
        next state: @autoclosure @escaping Supplier<State<E2>>
    ) -> State<Event> where E1.Event == Event, E2.Event == Event {
        event() ==> state()
    }
    
    static func when<E: CoreEvent & Equatable>(
        is event: @autoclosure @escaping Supplier<E>,
        next state: @autoclosure @escaping Supplier<State<E>>
    ) -> State<Event> where E.Event == Event {
        event() ==> state()
    }
    
    static func when<E: CoreEvent & Equatable>(
        is event: @autoclosure @escaping Supplier<E>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> where E.Event == Event {
        event() ==> state()
    }
    
    static func when<E1: CoreEvent, E2: CoreEvent>(
        is condition: @autoclosure @escaping Supplier<Condition<E1>>,
        next state: @autoclosure @escaping Supplier<State<E2>>
    ) -> State<Event> where E1.Event == Event, E2.Event == Event {
        condition() ==> state()
    }
    
    static func when<E: CoreEvent>(
        is condition: @autoclosure @escaping Supplier<Condition<E>>,
        next state: @autoclosure @escaping Supplier<State<E>>
    ) -> State<Event> where E.Event == Event {
        condition() ==> state()
    }
    
    static func when<E: CoreEvent>(
        is condition: @autoclosure @escaping Supplier<Condition<E>>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> where E.Event == Event {
        condition() ==> state()
    }
    
}

public func ==><Event: CoreEvent & Equatable, Event2: CoreEvent>(
    lhs: @autoclosure @escaping Supplier<Event>,
    rhs: @autoclosure @escaping Supplier<State<Event2>>
) -> State<Event.Event> where Event.Event == Event2.Event {
    State<Event.Event> { event in
        switch Event.map(event: event) {
        case .skip:
            return .skip
        case .set(let value):
            if lhs() == value {
                return .set(rhs().map(Event2.map(event:)))
            } else {
                return .skip
            }
        }
    }
}

public func ==><Event: CoreEvent & Equatable>(
    lhs: @autoclosure @escaping Supplier<Event>,
    rhs: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event.Event> {
    State<Event.Event> { event in
        switch Event.map(event: event) {
        case .skip:
            return .skip
        case .set(let value):
            if lhs() == value {
                return .set(rhs().map(Event.map(event:)))
            } else {
                return .skip
            }
        }
    }
}

public func ==><Event: CoreEvent & Equatable>(
    lhs: @autoclosure @escaping Supplier<Event>,
    rhs: @autoclosure @escaping Supplier<State<Event.Event>>
) -> State<Event.Event> {
    State<Event.Event> { event in
        switch Event.map(event: event) {
        case .skip:
            return .skip
        case .set(let value):
            if lhs() == value {
                return .set(rhs())
            } else {
                return .skip
            }
        }
    }
}

public func ==><Event: CoreEvent, Event2: CoreEvent>(
    lhs: @autoclosure @escaping Supplier<Condition<Event>>,
    rhs: @autoclosure @escaping Supplier<State<Event2>>
) -> State<Event.Event> where Event.Event == Event2.Event {
    State<Event.Event> { event in
        switch Event.map(event: event) {
        case .skip:
            return .skip
        case .set(let value):
            if lhs().predicate(value) {
                return .set(rhs().map(Event2.map(event:)))
            } else {
                return .skip
            }
        }
    }
}

public func ==><Event: CoreEvent>(
    lhs: @autoclosure @escaping Supplier<Condition<Event>>,
    rhs: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event.Event> {
    State<Event.Event> { event in
        switch Event.map(event: event) {
        case .skip:
            return .skip
        case .set(let value):
            if lhs().predicate(value) {
                return .set(rhs().map(Event.map(event:)))
            } else {
                return .skip
            }
        }
    }
}

public func ==><Event: CoreEvent>(
    lhs: @autoclosure @escaping Supplier<Condition<Event>>,
    rhs: @autoclosure @escaping Supplier<State<Event.Event>>
) -> State<Event.Event> {
    State<Event.Event> { event in
        switch Event.map(event: event) {
        case .skip:
            return .skip
        case .set(let value):
            if lhs().predicate(value) {
                return .set(rhs())
            } else {
                return .skip
            }
        }
    }
}

