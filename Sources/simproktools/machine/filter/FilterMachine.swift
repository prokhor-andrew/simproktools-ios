////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 29.03.2023.
////
//
//import simprokmachine
//
//
//
//public extension Machine {
//    
//    func filterInput(function: @escaping (Input, String, MachineLogger) -> Bool) -> Machine<Input, Output> {
//        filterInput(with: Void()) {
//            ($0, function($1, $2, $3))
//        }
//    }
//    
//    func filterInput<State>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (State, Input, String, MachineLogger) -> (newState: State, shouldPass: Bool)
//    ) -> Machine<Input, Output> {
//        mapInput(with: state()) { state, input, id, logger in
//            let (newState, shouldPass) = function(state, input, id, logger)
//            return (newState, shouldPass ? [input] : [])
//        }
//    }
//    
//    func filterOutput(function: @escaping (Output, String, MachineLogger) -> Bool) -> Machine<Input, Output> {
//        filterOutput(with: Void()) {
//            ($0, function($1, $2, $3))
//        }
//    }
//    
//    func filterOutput<State>(
//        with state: @escaping @autoclosure () -> State,
//        function: @escaping (State, Output, String, MachineLogger) -> (newState: State, shouldPass: Bool)
//    ) -> Machine<Input, Output> {
//        mapOutput(with: state()) { state, output, id, logger in
//            let (newState, shouldPass) = function(state, output, id, logger)
//            return (newState, shouldPass ? [output] : [])
//        }
//    }
//    
//    func biFilter<State>(
//        _ state: @escaping () -> State,
//        filterInput: @escaping (State, Input, String, MachineLogger) -> (State, Bool),
//        filterOutput: @escaping (State, Output, String, MachineLogger) -> (State, Bool)
//    ) -> Machine<Input, Output> {
//        biMap {
//            state()
//        } mapInput: {
//            let (newState, shouldPass) = filterInput($0, $1, $2, $3)
//            
//            return (newState, shouldPass ? [$1] : [])
//        } mapOutput: {
//            let (newState, shouldPass) = filterOutput($0, $1, $2, $3)
//                
//            return (newState, shouldPass ? [$1] : [])
//        }
//    }
//}
