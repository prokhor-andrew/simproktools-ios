//
//  StateBuilder.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


import simprokmachine


public struct StateBuilder<Event> {
 
    private let functions: [Mapper<Event, Step>]
    
    public init() {
        self.functions = []
    }
    
    private init(functions: [Mapper<Event, Step>]) {
        self.functions = functions
    }
    
    
    public func when(_ function: @escaping Mapper<Event, Bool>) -> StateBuilder<Event> {
        StateBuilder(functions: functions.copy(add: {
            function($0) ? .next : .skip
        }))
    }
    
    public func `while`(_ function: @escaping Mapper<Event, Bool>) -> StateBuilder<Event> {
        StateBuilder(functions: functions.copy(add: {
            function($0) ? .current : .next
        }))
    }
    
    public func until(_ function: @escaping Mapper<Event, Bool>) -> StateBuilder<Event> {
        StateBuilder(functions: functions.copy(add: {
            function($0) ? .next : .current
        }))
    }
    
    public func link(to state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event> {
        generate(index: 0, end: state())
    }
    
    
    private func generate(index: Int, end state: @autoclosure @escaping Supplier<State<Event>>) -> State<Event> {
        State<Event> { event in
            if index >= functions.count {
                return .set(state())
            } else {
                switch functions[index](event) {
                case .skip:
                    return .skip
                case .current:
                    return .set(generate(index: index, end: state()))
                case .next:
                    return .set(generate(index: index + 1, end: state()))
                }
            }
        }
    }
}

public extension StateBuilder where Event: Equatable {
    
    func when(is value: @autoclosure @escaping Supplier<Event>) -> StateBuilder<Event> {
        when { $0 == value() }
    }
    
    func when(not value: @autoclosure @escaping Supplier<Event>) -> StateBuilder<Event> {
        when { $0 != value() }
    }
    
    func `while`(is value: @autoclosure @escaping Supplier<Event>) -> StateBuilder<Event> {
        `while` { $0 == value() }
    }
    
    func `while`(not value: @autoclosure @escaping Supplier<Event>) -> StateBuilder<Event> {
        `while` { $0 != value() }
    }
    
    func until(is value: @autoclosure @escaping Supplier<Event>) -> StateBuilder<Event> {
        until { $0 == value() }
    }
    
    func until(not value: @autoclosure @escaping Supplier<Event>) -> StateBuilder<Event> {
        until { $0 != value() }
    }
}

private enum Step {
    case next
    case current
    case skip
}
