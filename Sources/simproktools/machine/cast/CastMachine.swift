//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 17.11.2023.
//

import simprokmachine


public extension Machine {
    
    func cast<RInput>(input: RInput.Type) -> Machine<RInput, Output> {
        mapInput { value in
            if let value = value as? Input {
                return [value]
            } else {
                return []
            }
        }
    }
    
    func cast<ROutput>(output: ROutput.Type) -> Machine<Input, ROutput> {
        mapOutput { value in
            if let value = value as? ROutput {
                return [value]
            } else {
                return []
            }
        }
    }
    
    func cast<RInput, ROutput>(input: RInput.Type, output: ROutput.Type) -> Machine<RInput, ROutput> {
        cast(output: output).cast(input: input)
    }
}
