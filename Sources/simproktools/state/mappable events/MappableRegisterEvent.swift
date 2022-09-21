//
//  MappableRegisterEvent.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public extension State where Event: CoreEvent {
    
    func register(
        function: @escaping Mapper<Event, Transition<StateWrapper<Event.Event>>>
    ) -> State<Event.Event> {
        map(Event.map(event:)).register { event in
            switch Event.map(event: event) {
            case .skip:
                return .skip
            case .set(let value):
                switch function(value) {
                case .skip:
                    return .skip
                case .set(let result):
                    return .set(result.state)
                }
            }
        }
    }
}

public extension State {
    
    static func register<E: CoreEvent>(
        _ state: State<E>,
        function: @escaping Mapper<E, Transition<StateWrapper<Event>>>
    ) -> State<Event> where E.Event == Event {
        state.register(function: function)
    }
}


public func register<Event: CoreEvent>(
    _ state: State<Event>,
    function: @escaping Mapper<Event, Transition<StateWrapper<Event.Event>>>
) -> State<Event.Event> {
    State.register(state, function: function)
}
