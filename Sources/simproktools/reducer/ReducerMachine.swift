//
//  ReducerMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A machine that receives input, reduces it into state and emits it.
public final class ReducerMachine<Event, State>: ParentMachine {
    public typealias Input = Event
    public typealias Output = State
    
    /// `ParentMachine` protocol property
    public let child: Machine<Input, Output>
    
    /// - parameter initial: initial state and array of outputs that are emitted when machine is subscribed to.
    /// - parameter queue: `ChildMachine` protocol property.
    /// - parameter reducer: a `BiMapper` object that accepts current state, received input and returns an object of `ReducerResult` type depending on which the state is either changed or not. 
    public init(_ initial: State, queue: MachineQueue = .new, reducer: @escaping BiMapper<State, Event, ReducerResult<State>>) {
        self.child = ~ClassicMachine(.set(initial, outputs: initial), queue: queue, reducer: { state, input in
            switch reducer(state, input) {
            case .set(let new):
                return .set(new, outputs: new)
            case .skip:
                return .set(state)
            }
        })
    }
}
