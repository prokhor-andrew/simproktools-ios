//
//  MergeMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


import simprokmachine


private final class MergeMachine<Input, Output>: ChildMachine {
    
    var queue: MachineQueue { .new }
    
    private let machines: [Machine<Input, Output>]
    
    private var subscriptions: [Subscription<Input>] = []
    
    init(_ machines: [Machine<Input, Output>]) {
        self.machines = machines
    }
    
    func process(input: Input?, callback: @escaping Handler<Output>) {
        if let input = input {
            subscriptions.forEach { $0.send(input: input) }
        } else {
            subscriptions = machines.map { ManualRoot(child: $0).start(callback: callback) }
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
    
    static func merge(_ machines: [Machine<Input, Output>]) -> Machine<Input, Output> {
        ~MergeMachine(machines)
    }
    
    static func merge(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
        Machine.merge(machines)
    }
}


public func merge<Input, Output>(_ machines: [Machine<Input, Output>]) -> Machine<Input, Output> {
    Machine.merge(machines)
}

public func merge<Input, Output>(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
    Machine.merge(machines)
}
