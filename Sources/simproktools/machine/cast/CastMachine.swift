//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 17.11.2023.
//

import simprokmachine


public extension Machine {
    
    func cast<RInput>(input: RInput.Type, doOn: @escaping ((Loggable) -> Void) -> Void = { _ in }) -> Machine<RInput, Output> {
        cast(input: input, output: Output.self, doOnInput: doOn)
    }
    
    func cast<ROutput>(output: ROutput.Type, doOn: @escaping ((Loggable) -> Void) -> Void = { _ in }) -> Machine<Input, ROutput> {
        cast(input: Input.self, output: output, doOnOutput: doOn)
    }
    
    func cast<RInput, ROutput>(
        input: RInput.Type,
        output: ROutput.Type,
        doOnInput: @escaping ((Loggable) -> Void) -> Void = { _ in },
        doOnOutput: @escaping ((Loggable) -> Void) -> Void = { _ in }
    ) -> Machine<RInput, ROutput> {
        biMap(
            mapInput: { value, logger in
                doOnInput(logger)
                if let value = value as? Input {
                    return [value]
                } else {
                    return []
                }
            }, mapOutput: { value, logger in
                doOnOutput(logger)
                if let value = value as? ROutput {
                    return [value]
                } else {
                    return []
                }
            }
        )
    }
}
