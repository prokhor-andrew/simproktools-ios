//
//  ClassicResult.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


/// A type that represents a behavior of `ClassicMachine`.
public struct ClassicResult<State, Output> {
    
    /// State
    public let state: State
    
    /// Emitted outputs
    public let outputs: [Output]
    
    private init(_ state: State, _ outputs: [Output]) {
        self.state = state
        self.outputs = outputs
    }
    
    /// Creates a `ClassicResult` object that is when returned from `ClassicMachine` reducer changes state and emits outputs.
    /// - parameter state: new state.
    /// - parameter outputs: emitted outputs.
    public static func set(_ state: State, outputs: Output...) -> ClassicResult<State, Output> {
        .init(state, outputs)
    }
    
    /// Creates a `ClassicResult` object that is when returned from `ClassicMachine` reducer changes state and emits outputs.
    /// - parameter state: new state.
    /// - parameter outputs: emitted outputs.
    public static func set(_ state: State, outputs: [Output]) -> ClassicResult<State, Output> {
        .init(state, outputs)
    }
}
