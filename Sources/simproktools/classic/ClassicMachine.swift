//
//  ClassicMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A machine that receives input, reduces it into state and array of outputs that are emitted.
public final class ClassicMachine<State, Input, Output>: ChildMachine {
    
    private var state: ClassicResult<State, Output>
    private let reducer: BiMapper<State, Input, ClassicResult<State, Output>>
    
    /// `ChildMachine` protocol property
    public let queue: MachineQueue
    
    /// - parameter initial: initial state and array of outputs that are emitted when machine is subscribed to.
    /// - parameter queue: `ChildMachine` protocol property.
    /// - parameter reducer: a `BiMapper` object that accepts current state, received input and returns an object of `ClassicResult` type that contains new state and emitted array of outputs.
    public init(
        _ initial: ClassicResult<State, Output>,
        queue: MachineQueue = .new,
        reducer: @escaping BiMapper<State, Input, ClassicResult<State, Output>>
    ) {
        self.queue = queue
        self.state = initial
        self.reducer = reducer
    }
    
    /// `ChildMachine` protocol method
    public func process(input: Input?, callback: @escaping Handler<Output>) {
        if let input = input {
            state = reducer(state.state, input)
        }
        state.outputs.forEach { callback($0) }
    }
}
