//
//  SingleMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A machine that emits the injected value *when subscribed*.
public final class SingleMachine<Input, Output>: ChildMachine {
    
    private let value: Output
    
    /// - parameter value: a value that is emitted when machine is subscribed to.
    public init(_ value: Output) {
        self.value = value
    }
    
    /// `ChildMachine` protocol property
    public var queue: MachineQueue { .main }
    
    /// `ChildMachine` protocol method
    public func process(input: Input?, callback: @escaping Handler<Output>) {
        if input == nil {
            callback(value)
        }
    }
}
