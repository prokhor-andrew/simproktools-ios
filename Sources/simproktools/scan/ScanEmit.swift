//
//  ScanEmit.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


internal enum ScanEmit<ParentInput, ParentOutput, ChildInput, ChildOutput> {
    case toMachine(ChildInput)
    case toReducer(ScanInput<ParentInput, ChildOutput>)
    case out(ParentOutput)
}
