//
//  StateMachine.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


private final class StateMachine<Event>: ParentMachine {
    public typealias Input = Event
    public typealias Output = Event
    
    public let child: Machine<Input, Output>
    
    public init(_ initial: State<Event>, queue: MachineQueue = .new) {
        self.child = Machine.classic(.set(initial), queue: queue) { state, event in
            switch state.transit(event) {
            case .set(let new):
                return .set(new, outputs: event)
            case .skip:
                return .set(state)
            }
        }
    }
}



public extension MachineType where Input == Output {
    
    static func state<Event>(
        _ initial: State<Event>, queue: MachineQueue = .new
    ) -> Machine<Event, Event> where Event == Input, Event == Output {
        ~StateMachine(initial, queue: queue)
    }
}
