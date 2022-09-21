//
//  Spawn.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine

public extension State {
    
    func spawn() -> State<Event> {
        State { event in
            switch transit(event) {
            case .skip:
                return .skip
            case .set(let new):
                return .set(.merge([new, spawn()]))
            }
        }
    }
    
    static func spawn(_ state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event> {
        state().spawn()
    }
}

public func spawn<Event>(_ state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event> {
    State<Event>.spawn(state())
}
