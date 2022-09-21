//
//  Map.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine



public func map<Event, T>(
    _ state: State<Event>,
    function: @escaping Mapper<T, Transition<Event>>
) -> State<T> {
    State<Event>.map(state, function: function)
}


public extension State {
    
    static func map<T>(
        _ state: State<Event>,
        function: @escaping Mapper<T, Transition<Event>>
    ) -> State<T> {
        state.map(function)
    }
    
    func map<T>(_ function: @escaping Mapper<T, Transition<Event>>) -> State<T> {
        State<T> { event in
            switch function(event) {
            case .skip:
                return .skip
            case .set(let mapped):
                switch transit(mapped) {
                case .skip:
                    return .skip
                case .set(let new):
                    return .set(new.map(function))
                }
            }
        }
    }
}
