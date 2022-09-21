//
//  WhileNot.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func `while`<Event: Equatable>(
    not event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State<Event>.while(not: event(), next: state())
}

public func `while`<Event>(
    not condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State<Event>.while(not: condition(), next: state())
}


public extension State {

    static func `while`<Event: Equatable>(
        not event: @autoclosure @escaping Supplier<Event>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> {
        event() <=> state()
    }

    static func `while`<Event>(
        not condition: @autoclosure @escaping Supplier<Condition<Event>>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> {
        condition() <=> state()
    }
}


infix operator <=>: AssignmentPrecedence
public func <=><Event>(
    lhs: @autoclosure @escaping Supplier<Event>,
    rhs: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> where Event: Equatable {
    State { event in
        event == lhs() ? .set(rhs()) : .set(lhs() <=> rhs())
    }
}

public func <=><Event>(
    lhs: @autoclosure @escaping Supplier<Condition<Event>>,
    rhs: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State { event in
        lhs().predicate(event) ? .set(rhs()) : .set(lhs() <=> rhs())
    }
}
