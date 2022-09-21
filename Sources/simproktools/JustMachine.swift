//
//  JustMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


/// A machine that emits the injected value when subscribed and every time input is received.
private final class JustMachine<Input, Output>: ChildMachine {
    
    private let value: Output
    
    /// - parameter value: a value that is sent back every time input received
    public init(_ value: Output) {
        self.value = value
    }
    
    /// `ChildMachine` protocol property
    public var queue: MachineQueue { .main } 
    
    /// `ChildMachine` protocol method
    public func process(input: Input?, callback: @escaping Handler<Output>) {
        callback(value)
    }
}



public extension MachineType {
    
    static func just(_ value: Output) -> Machine<Input, Output> {
        ~JustMachine(value)
    }
}

public func just<Input, Output>(_ value: Output) -> Machine<Input, Output> {
    Machine.just(value)
}
