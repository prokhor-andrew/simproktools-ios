//
//  StateWrapper.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


public struct StateWrapper<Event> {
    
    internal let state: State<Event>
    
    public init<C: CoreEvent>(_ state: State<C>) where C.Event == Event {
        self.state = state.map(C.map(event:))
    }
    
    public static func wrap<C: CoreEvent>(_ state: State<C>) -> StateWrapper<Event> where C.Event == Event {
        .init(state)
    }
}

public extension State where Event: CoreEvent {
    
    prefix static func ~(operand: Self) -> StateWrapper<Event.Event> {
        .wrap(operand)
    }
}
