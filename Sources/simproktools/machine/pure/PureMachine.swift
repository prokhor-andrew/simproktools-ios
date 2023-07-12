//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 12.07.2023.
//

import simprokmachine

public extension Machine {
    
    private actor Dummy<Output> {
        
        var callback: ((Output) async -> Void)?
    }
    
    static func pure(onProcess: @escaping (Input, (Output) async -> Void) async -> Void) -> Machine<Input, Output> {
        Machine {
            Dummy()
        } onChange: {
            $0.callback = $1
        } onProcess: {
            guard let callback = $0.callback else { return }
            await onProcess($1, callback)
        }
    }
}
