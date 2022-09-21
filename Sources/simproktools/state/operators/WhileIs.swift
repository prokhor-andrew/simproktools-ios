//
//  WhileIs.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func `while`<Event: Equatable>(
    is event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State<Event>.while(is: event(), next: state())
}

public func `while`<Event>(
    is condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State<Event>.while(is: condition(), next: state())
}

public extension State {
    
    static func `while`<Event: Equatable>(
        is event: @autoclosure @escaping Supplier<Event>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> {
        event() <!> state()
    }

    static func `while`<Event>(
        is condition: @autoclosure @escaping Supplier<Condition<Event>>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> {
        condition() <!> state()
    }
}

infix operator <!>: AssignmentPrecedence
public func <!><Event>(
    lhs: @autoclosure @escaping Supplier<Event>,
    rhs: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> where Event: Equatable {
    State { event in
        event != lhs() ? .set(rhs()) : .set(lhs() <!> rhs())
    }
}

public func <!><Event>(
    lhs: @autoclosure @escaping Supplier<Condition<Event>>,
    rhs: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State { event in
        !lhs().predicate(event) ? .set(rhs()) : .set(lhs() <=> rhs())
    }
}

