//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokmachine


public extension Machine {
    
    
    func doOnInput(function: @escaping (Input, (Loggable) -> Void) -> Void) -> Machine<Input, Output> {
        doOnInput(with: Void()) {
            function($1, $2)
            return $0
        }
    }
    
    func doOnInput<State>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Input, (Loggable) -> Void) -> State
    ) -> Machine<Input, Output> {
        mapInput(with: state()) {
            (function($0, $1, $2), [$1])
        }
    }
    
    
    func doOnOutput(function: @escaping (Output, (Loggable) -> Void) -> Void) -> Machine<Input, Output> {
        doOnOutput(with: Void()) {
            function($1, $2)
            return $0
        }
    }
    
    func doOnOutput<State>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Output, (Loggable) -> Void) -> State
    ) -> Machine<Input, Output> {
        mapOutput(with: state()) {
            (function($0, $1, $2), [$1])
        }
    }
    
    func biDoOn<State>(
        _ state: @escaping () -> State,
        doOnInput: @escaping (State, Input, (Loggable) -> Void) -> State,
        doOnOutput: @escaping (State, Output, (Loggable) -> Void) -> State
    ) -> Machine<Input, Output> {
        biMap {
            state()
        } mapInput: {
            (doOnInput($0, $1, $2), [$1])
        } mapOutput: {
            (doOnOutput($0, $1, $2), [$1])
        }
    }
}
