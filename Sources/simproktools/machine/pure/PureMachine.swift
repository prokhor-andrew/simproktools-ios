//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 12.07.2023.
//

import simprokmachine

public extension Machine {
    
    private actor Dummy {
        
        let logger: (Message) -> Void
        
        var callback: MachineCallback<Output>?
        
        init(_ logger: @escaping (Message) -> Void) {
            self.logger = logger
        }
    }
    
    static func pure(onProcess: @escaping (Input, MachineCallback<Output>, (Message) -> Void) async -> Void) -> Machine<Input, Output, Message> {
        Machine { logger in
            Dummy(logger)
        } onChange: {
            $0.callback = $1
        } onProcess: {
            guard let callback = $0.callback else { return }
            await onProcess($1, callback, $0.logger)
        }
    }
}
