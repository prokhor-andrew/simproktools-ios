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
//public extension Machine {
//    
//    
//    func doOnInput(function: @escaping (Input, String, MachineLogger) -> Void) -> Machine<Input, Output> {
//        doOnInput(with: Void()) {
//            function($1, $2, $3)
//            return $0
//        }
//    }
//    
//    func doOnInput<State>(
//        with state: @escaping @autoclosure () -> State,
//        function: @escaping (State, Input, String, MachineLogger) -> State
//    ) -> Machine<Input, Output> {
//        mapInput(with: state()) {
//            (function($0, $1, $2, $3), [$1])
//        }
//    }
//    
//    
//    func doOnOutput(function: @escaping (Output, String, MachineLogger) -> Void) -> Machine<Input, Output> {
//        doOnOutput(with: Void()) {
//            function($1, $2, $3)
//            return $0
//        }
//    }
//    
//    func doOnOutput<State>(
//        with state: @escaping @autoclosure () -> State,
//        function: @escaping (State, Output, String, MachineLogger) -> State
//    ) -> Machine<Input, Output> {
//        mapOutput(with: state()) {
//            (function($0, $1, $2, $3), [$1])
//        }
//    }
//    
//    func biDoOn<State>(
//        _ state: @escaping () -> State,
//        doOnInput: @escaping (State, Input, String, MachineLogger) -> State,
//        doOnOutput: @escaping (State, Output, String, MachineLogger) -> State
//    ) -> Machine<Input, Output> {
//        biMap {
//            state()
//        } mapInput: {
//            (doOnInput($0, $1, $2, $3), [$1])
//        } mapOutput: {
//            (doOnOutput($0, $1, $2, $3), [$1])
//        }
//    }
//}
