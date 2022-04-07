//
//  ValueMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A machine that accepts a value as input and immediately emits it as output. When subscribed - emits `nil`.
public final class ValueMachine<T>: ChildMachine {
    public typealias Input = T
    public typealias Output = T?
    
    /// Initializes a machine
    public init() {
    }
    
    /// `ChildMachine` protocol property
    public var queue: MachineQueue { .main }
    
    /// `ChildMachine` protocol method
    public func process(input: T?, callback: @escaping Handler<T?>) {
        callback(input)
    }
}
