//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokmachine


public extension Machine {
    
    
    func doOnInput(function: @escaping (Input) -> Void) -> Machine<Input, Output> {
        doOnInput(with: Void()) {
            function($1)
            return $0
        }
    }
    
    func doOnInput<State>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Input) -> State
    ) -> Machine<Input, Output> {
        mapInput(with: state()) {
            (function($0, $1), [$1])
        }
    }
    
    
    func doOnOutput(function: @escaping (Output) -> Void) -> Machine<Input, Output> {
        doOnOutput(with: Void()) {
            function($1)
            return $0
        }
    }
    
    func doOnOutput<State>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Output) -> State
    ) -> Machine<Input, Output> {
        mapOutput(with: state()) {
            (function($0, $1), [$1])
        }
    }
    
    func biDoOn<State>(
            _ state: @escaping () -> State,
            doOnInput: @escaping (State, Input) -> State,
            doOnOutput: @escaping (State, Output) -> State
    ) -> Machine<Input, Output> {
        biMap {
            state()
        } mapInput: {
            (doOnInput($0, $1), [$1])
        } mapOutput: {
            (doOnOutput($0, $1), [$1])
        }
    }
}
