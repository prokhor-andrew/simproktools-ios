//
//  StatefulMachine.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine

private enum LayerMachineEvent<Object, Input, Output> {
    case toReducer(Input)
    case toInternal(BiHandler<Object, Handler<Input>>)
    case toParent(Ward<Output>)
}

private final class LayerMachine<Object, Event>: ChildMachine {
    typealias Input = BiHandler<Object, Handler<Event>>
    typealias Output = Event
    
    private let object: Object
    
    init(object: Object) {
        self.object = object
    }
    
    var queue: MachineQueue { .new }
    
    func process(input: BiHandler<Object, Handler<Event>>?, callback: @escaping Handler<Event>) {
        input?(object, callback)
    }
}

public extension State {
    
    func on<Object, Output>(
        _ object: Object,
        function: @escaping Mapper<Event, OutputEvent<Object, Output, Event>>
    ) -> Machine<Event, Output> {
        let machine1: Machine<
            LayerMachineEvent<Object, Event, Output>,
            LayerMachineEvent<Object, Event, Output>
        > =
        Machine.state(self).outward { event in
            switch function(event) {
            case .external(let output):
                return .set(.toParent(output))
            case .internal(let handler):
                return .set(.toInternal(handler))
            }
        }.inward { parent in
            switch parent {
            case .toReducer(let event):
                return .set(event)
            case .toInternal, .toParent:
                return .set()
            }
        }
        
        let machine2: Machine<
            LayerMachineEvent<Object, Event, Output>,
            LayerMachineEvent<Object, Event, Output>
        > = LayerMachine<Object, Event>(object: object).outward { event in
            .set(.toReducer(event))
        }.inward { parent in
            switch parent {
            case .toInternal(let handler):
                return .set(handler)
            case .toParent, .toReducer:
                return .set()
            }
        }
        
        return Machine.merge(machine1, machine2).redirect { event in
            switch event {
            case .toParent:
                return .prop
            case .toReducer, .toInternal:
                return .back(event)
            }
        }.outward { event in
            switch event {
            case .toParent(let ward):
                return ward
            case .toReducer, .toInternal:
                return .set()
            }
        }.inward { input in
            .set(.toReducer(input))
        }
    }
}

public enum OutputEvent<Object, Output, Input> {
    case `internal`(BiHandler<Object, Handler<Input>>)
    case external(Ward<Output>)
}
