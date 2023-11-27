//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokmachine


public extension Machine {
    
    
    func doOnInput(function: @escaping (Input, (Message) -> Void) -> Void) -> Machine<Input, Output, Message> {
        doOnInput(with: Void()) {
            function($1, $2)
            return $0
        }
    }
    
    func doOnInput<State>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Input, (Message) -> Void) -> State
    ) -> Machine<Input, Output, Message> {
        mapInput(with: state()) {
            (function($0, $1, $2), [$1])
        }
    }
    
    
    func doOnOutput(function: @escaping (Output, (Message) -> Void) -> Void) -> Machine<Input, Output, Message> {
        doOnOutput(with: Void()) {
            function($1, $2)
            return $0
        }
    }
    
    func doOnOutput<State>(
        with state: @escaping @autoclosure () -> State,
        function: @escaping (State, Output, (Message) -> Void) -> State
    ) -> Machine<Input, Output, Message> {
        mapOutput(with: state()) {
            (function($0, $1, $2), [$1])
        }
    }
    
    func biDoOn<State>(
        _ state: @escaping () -> State,
        doOnInput: @escaping (State, Input, (Message) -> Void) -> State,
        doOnOutput: @escaping (State, Output, (Message) -> Void) -> State
    ) -> Machine<Input, Output, Message> {
        biMap {
            state()
        } mapInput: {
            (doOnInput($0, $1, $2), [$1])
        } mapOutput: {
            (doOnOutput($0, $1, $2), [$1])
        }
    }
}
