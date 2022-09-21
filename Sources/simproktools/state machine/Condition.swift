//
//  Condition.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public struct Condition<T> {
    
    public let predicate: Mapper<T, Bool>
    
    public init(predicate: @escaping Mapper<T, Bool>) {
        self.predicate = predicate
    }
}
