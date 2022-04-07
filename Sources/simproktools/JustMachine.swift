//
//  JustMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A machine that emits the injected value when subscribed and every time input is received.
public final class JustMachine<Input, Output>: ChildMachine {
    
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

