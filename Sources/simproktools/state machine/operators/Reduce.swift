//
//  Reduce.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public extension State {
    
    static func reduce<S>(
        _ initial: S,
        function: @escaping BiMapper<S, Event, Transition<S>>
    ) -> State<Event> {
        State { event in
            switch function(initial, event) {
            case .skip:
                return .skip
            case .set(let new):
                return .set(reduce(new, function: function))
            }
        }
    }
    
    static func reduce<S>(
        function: @escaping BiMapper<S?, Event, Transition<S>>
    ) -> State<Event> {
        State { event in
            switch function(nil, event) {
            case .skip:
                return .skip
            case .set(let new):
                return .set(reduce(new, function: function))
            }
        }
    }
}

public func reduce<S, Event>(
    _ initial: S,
    function: @escaping BiMapper<S, Event, Transition<S>>
) -> State<Event> {
    State<Event>.reduce(initial, function: function)
}

public func reduce<S, Event>(
    function: @escaping BiMapper<S?, Event, Transition<S>>
) -> State<Event> {
    State<Event>.reduce(function: function)
}

public extension StateBuilder {
    
    func reduce<S>(
        _ initial: S,
        function: @escaping BiMapper<S, Event, Transition<S>>
    ) -> State<Event> {
        link(to: reduce(initial, function: function))
    }
    
    func reduce<S>(
        function: @escaping BiMapper<S?, Event, Transition<S>>
    ) -> State<Event> {
        link(to: State.reduce(function: function))
    }
}
