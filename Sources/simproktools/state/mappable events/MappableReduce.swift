//
//  MappableMergeEvent.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public extension State {
    
    static func reduce<S, E: CoreEvent>(
        _ initial: S,
        function: @escaping BiMapper<S, E, Transition<S>>
    ) -> State<Event> where E.Event == Event {
        State<E>.reduce(initial, function: function).map(E.map(event:))
    }
    
    static func reduce<S, E: CoreEvent>(
        function: @escaping BiMapper<S?, E, Transition<S>>
    ) -> State<Event> where E.Event == Event {
        State<E>.reduce(function: function).map(E.map(event:))
    }
}

public func reduce<S, Event: CoreEvent>(
    _ initial: S,
    function: @escaping BiMapper<S, Event, Transition<S>>
) -> State<Event.Event> {
    State<Event.Event>.reduce(initial, function: function)
}

public func reduce<S, Event: CoreEvent>(
    function: @escaping BiMapper<S?, Event, Transition<S>>
) -> State<Event.Event> {
    State<Event.Event>.reduce(function: function)
}
