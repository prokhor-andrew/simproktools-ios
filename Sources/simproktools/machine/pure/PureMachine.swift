//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 12.07.2023.
//

import simprokmachine

public extension Machine {
    
    private actor Dummy {
        
        let logger: (Loggable) -> Void
        
        var callback: MachineCallback<Output>?
        
        init(_ logger: @escaping (Loggable) -> Void) {
            self.logger = logger
        }
    }
    
    static func pure(onProcess: @escaping (Input, MachineCallback<Output>, String, (Loggable) -> Void) async -> Void) -> Machine<Input, Output> {
        Machine { id, logger in
            Dummy(logger)
        } onChange: { obj, id, callback in
            obj.callback = callback
        } onProcess: { obj, id, input in
            guard let callback = obj.callback else { return }
            await onProcess(input, callback, id, obj.logger)
        }
    }
}
