//
//  Array+Copy.swift
//  simprokmachine
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import Foundation


internal extension Dictionary {
    
    func copyAdd(key: Key, element: Value) -> Dictionary<Key, Value> {
        var copied = self
        copied[key] = element
        return copied
    }
}

