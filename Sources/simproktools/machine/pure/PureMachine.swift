//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 12.07.2023.
//

import simprokmachine

public extension Machine {
    
    private actor Dummy {
        
        let id: String
        let logger: (Loggable) -> Void
        
        var callback: MachineCallback<Output>?
        
        init(id: String, logger: @escaping (Loggable) -> Void) {
            self.id = id
            self.logger = logger
        }
    }
    
    static func pure(onProcess: @escaping (Input, MachineCallback<Output>, String, (Loggable) -> Void) async -> Void) -> Machine<Input, Output> {
        Machine { id, logger in
            Dummy(id: id, logger: logger)
        } onChange: { obj, callback in
            obj.callback = callback
        } onProcess: { obj, input in
            guard let callback = obj.callback else { return }
            await onProcess(input, callback, obj.id, obj.logger)
        }
    }
}
