//
//  ScanOutput.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


/// A type that represents a behavior of `MachineType.scan()` operator.
/// Returned from `MachineType.scan()`'s `reducer` method.
public enum ScanOutput<ParentOutput, MachineInput> {
    /// Changes current state of `MachineType.scan()` into `MachineInput`
    case state(MachineInput)
    
    /// Emits an output object to the parent machine.
    case event(ParentOutput)
}
