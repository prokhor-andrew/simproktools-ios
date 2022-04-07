//
//  ReducerResult.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A type that represents a behavior of `ReducerMachine`.
public enum ReducerResult<State> {
    
    /// Returning this value from `ReducerMachine`'s `reducer` method ensures that the state *will* be changed and emitted.
    case set(State)
    
    /// Returning this value from `ReducerMachine`'s `reducer` method ensures that the state *won't* be changed and emitted .
    case skip
}
