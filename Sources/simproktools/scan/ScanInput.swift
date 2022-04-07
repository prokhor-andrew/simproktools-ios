//
//  ScanInput.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A type that represents a behavior of `MachineType.scan()` operator.
/// Received by `MachineType.scan()`'s `reducer` as event.
public enum ScanInput<ParentInput, MachineOutput> {
    /// Received from `MachineType.self` object.
    case inner(MachineOutput)
    
    /// Received from parent machine.
    case outer(ParentInput)
}
