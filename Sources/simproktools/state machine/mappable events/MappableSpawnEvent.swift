//
//  MappableSpawnEvent.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine

public extension State where Event: CoreEvent {
    
    func spawn() -> State<Event.Event> {
        map(Event.map(event:)).spawn()
    }
}

public extension State {
    
    static func spawn<E: CoreEvent>(
        _ state: @autoclosure @escaping Supplier<State<E>>
    ) -> State<Event> where E.Event == Event {
        state().spawn()
    }
}

public func spawn<Event: CoreEvent>(_ state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event.Event> {
    State.spawn(state())
}
