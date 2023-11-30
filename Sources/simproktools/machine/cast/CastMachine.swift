//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 17.11.2023.
//

import simprokmachine


public extension Machine {
    
    func cast<RInput>(
        input: RInput.Type,
        doOnEvent: @escaping (RInput, (Loggable) -> Void) -> Void = { _,_ in }
    ) -> Machine<RInput, Output> {
        cast(input: input, output: Output.self, doOnInput: doOnEvent)
    }
    
    func cast<ROutput>(
        output: ROutput.Type,
        doOnEvent: @escaping (Output, (Loggable) -> Void) -> Void = { _,_ in }
    ) -> Machine<Input, ROutput> {
        cast(input: Input.self, output: output, doOnOutput: doOnEvent)
    }
    
    func cast<RInput, ROutput>(
        input: RInput.Type,
        output: ROutput.Type,
        doOnInput: @escaping (RInput, (Loggable) -> Void) -> Void = { _,_ in },
        doOnOutput: @escaping (Output, (Loggable) -> Void) -> Void = { _,_ in }
    ) -> Machine<RInput, ROutput> {
        biMap(
            mapInput: { value, logger in
                doOnInput(value, logger)
                if let value = value as? Input {
                    return [value]
                } else {
                    return []
                }
            }, mapOutput: { value, logger in
                doOnOutput(value, logger)
                if let value = value as? ROutput {
                    return [value]
                } else {
                    return []
                }
            }
        )
    }
}
