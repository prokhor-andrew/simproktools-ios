//
//  DynamicMachine.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


import simprokmachine


private final class DynamicMachine<Payload, Input, Output>: ChildMachine {
    typealias Input = Input
    typealias Output = Output

    private var payload: Payload?
    private var machines: [Machine<Input, Output>]
    
    private var subscriptions: [ObjectIdentifier: Subscription<Input>] = [:]
    
    private let function: BiMapper<DynamicResult<Payload, Input, Output>?, Input, DynamicResult<Payload, Input, Output>>
    
    init(
        _ initial: DynamicResult<Payload, Input, Output>,
        function: @escaping BiMapper<DynamicResult<Payload, Input, Output>, Input, DynamicResult<Payload, Input, Output>>
    ) {
        self.payload = initial.payload
        self.machines = initial.machines
        self.function = { function($0!, $1) }
    }
    
    init(
        function: @escaping BiMapper<DynamicResult<Payload, Input, Output>?, Input, DynamicResult<Payload, Input, Output>>
    ) {
        self.payload = nil
        self.machines = []
        self.function = function
    }
    
    var queue: MachineQueue { .new }
    
    func process(input: Input?, callback: @escaping Handler<Output>) {
        if let input = input {
            let state: DynamicResult<Payload, Input, Output>?
            if let payload = payload {
                state = .init(payload, machines)
            } else {
                state = nil
            }
            
            let result = function(state, input)
            
            let new = result.machines
            
            machines.forEach { old in
                if !new.contains(where: { new in old === new }) {
                    subscriptions.removeValue(forKey: ObjectIdentifier(old))
                }
            }
            
            new.forEach { new in
                if !machines.contains(where: { old in old === new }) {
                    subscriptions[ObjectIdentifier(new)] = ManualRoot(child: new).start(callback: callback)
                }
            }
            
            payload = result.payload
            machines = new
            
            subscriptions.forEach { $0.value.send(input: input) }
            
        } else {
            subscriptions = machines.reduce([:]) { state, machine in
                state.copyAdd(key: ObjectIdentifier(machine), element: ManualRoot(child: machine).start(callback: callback))
            }
        }
    }
    
    private final class ManualRoot<Input, Output>: RootMachine {
        
        let child: Machine<Input, Output>
        
        init(child: Machine<Input, Output>) {
            self.child = child
        }
    }
}

public extension MachineType {

    static func `dynamic`<Payload>(
        function: @escaping BiMapper<DynamicResult<Payload, Input, Output>?, Input, DynamicResult<Payload, Input, Output>>
    ) -> Machine<Input, Output> {
        ~DynamicMachine(function: function)
    }
    
    static func `dynamic`<Payload>(
        _ initial: DynamicResult<Payload, Input, Output>,
        function: @escaping BiMapper<DynamicResult<Payload, Input, Output>, Input, DynamicResult<Payload, Input, Output>>
    ) -> Machine<Input, Output> {
        ~DynamicMachine(initial, function: function)
    }
}


public func `dynamic`<Payload, Input, Output>(
    function: @escaping BiMapper<DynamicResult<Payload, Input, Output>?, Input, DynamicResult<Payload, Input, Output>>
) -> Machine<Input, Output> {
    Machine.dynamic(function: function)
}

public func `dynamic`<Payload, Input, Output>(
    _ initial: DynamicResult<Payload, Input, Output>,
    function: @escaping BiMapper<DynamicResult<Payload, Input, Output>, Input, DynamicResult<Payload, Input, Output>>
) -> Machine<Input, Output> {
    Machine.dynamic(initial, function: function)
}
