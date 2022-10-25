//
//  DynamicResult.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public struct DynamicResult<Payload, Input, Output> {
    
    public let payload: Payload
    public let machines: [Machine<Input, Output>]
    
    public init(_ payload: Payload, _ machines: [Machine<Input, Output>]) {
        self.payload = payload
        self.machines = machines
    }
    
    public init(_ payload: Payload, _ machines: Machine<Input, Output>...) {
        self.init(payload, machines)
    }
}
