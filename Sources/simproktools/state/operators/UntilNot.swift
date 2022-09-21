//
//  UntilNot.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func until<Event: Equatable>(
    not event: @autoclosure @escaping Supplier<Event>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State<Event>.until(not: event(), next: state())
}

public func until<Event>(
    not condition: @autoclosure @escaping Supplier<Condition<Event>>,
    next state: @autoclosure @escaping Supplier<State<Event>>
) -> State<Event> {
    State<Event>.until(not: condition(), next: state())
}


public extension State {


    static func until<Event: Equatable>(
        not event: @autoclosure @escaping Supplier<Event>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> {
        State<Event>.`while`(is: event(), next: state())
    }

    static func until<Event>(
        not condition: @autoclosure @escaping Supplier<Condition<Event>>,
        next state: @autoclosure @escaping Supplier<State<Event>>
    ) -> State<Event> {
        State<Event>.`while`(is: condition(), next: state())
    }
}
