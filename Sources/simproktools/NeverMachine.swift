//
//  NeverMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


/// A machine that when subscribed or receives input - ignores it, never emitting output.
public final class NeverMachine<Input, Output>: ChildMachine {
    
    /// Initializes a machine
    public init() {
    }
    
    /// `ChildMachine` protocol property
    public var queue: MachineQueue { .main }
    
    /// `ChildMachine` protocol method
    public func process(input: Input?, callback: @escaping Handler<Output>) {
        // do nothing, as we never should call the callback
    }
}
