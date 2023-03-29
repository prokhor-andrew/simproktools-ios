//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokmachine



public extension Machine {
    
    func filterInput(function: @escaping Mapper<Input, Bool>) -> Machine<Input, Output> {
        filterInput(with: Void()) {
            ($0, function($1))
        }
    }
    
    func filterInput<State>(with state: State, function: @escaping BiMapper<State, Input, (newState: State, shouldPass: Bool)>) -> Machine<Input, Output> {
        mapInput(with: state) { state, input in
            let (newState, shouldPass) = function(state, input)
            return (newState, shouldPass ? [input] : [])
        }
    }
    
    func filterOutput(function: @escaping Mapper<Output, Bool>) -> Machine<Input, Output> {
        filterOutput(with: Void()) {
            ($0, function($1))
        }
    }
    
    func filterOutput<State>(with state: State, function: @escaping BiMapper<State, Output, (newState: State, shouldPass: Bool)>) -> Machine<Input, Output> {
        mapOutput(with: state) { state, output in
            let (newState, shouldPass) = function(state, output)
            return (newState, shouldPass ? [output] : [])
        }
    }
}
