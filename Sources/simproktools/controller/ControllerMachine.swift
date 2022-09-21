//
//  ControllerMachine.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine

private enum ControllerEvent<Input, InternalOutput, ExternalOutput> {
    case toReducer(Input)
    case toInternal(InternalOutput)
    case toExternal(ExternalOutput)
}


public extension MachineType {
    
    func controller<Event, InternalOutput, ExternalOutput>(
        _ state: State<Event>,
        function: @escaping Mapper<Event, Ward<ControllerResult<InternalOutput, ExternalOutput>>>
    ) -> Machine<Event, ExternalOutput> where Event == Output, InternalOutput == Input {
        let filter: Machine<
            ControllerEvent<Event, InternalOutput, ExternalOutput>,
            ControllerEvent<Event, InternalOutput, ExternalOutput>
        >
        = Machine.state(state).inward { input in
            switch input {
            case .toReducer(let value):
                return .set(value)
            case .toInternal, .toExternal:
                return .set()
            }
        }.outward { event in
            .set(function(event).values.map { result in
                switch result {
                case .ext(let ext):
                    return ControllerEvent<Event, InternalOutput, ExternalOutput>.toExternal(ext)
                case .int(let int):
                    return ControllerEvent<Event, InternalOutput, ExternalOutput>.toInternal(int)
                }
            })
        }
        
        let int: Machine<
            ControllerEvent<Event, InternalOutput, ExternalOutput>,
            ControllerEvent<Event, InternalOutput, ExternalOutput>
        > = inward { input in
            switch input {
            case .toInternal(let value):
                return .set(value)
            case .toReducer, .toExternal:
                return .set()
            }
        }.outward { event in
            .set(.toReducer(event))
        }
        
        let out: Machine<Event, ExternalOutput> = Machine.merge(
            filter,
            int
        ).redirect { event in
            switch event {
            case .toReducer, .toInternal:
                return .back(event)
            case .toExternal:
                return .prop
            }
        }.inward { input in
            .set(.toReducer(input))
        }.outward { output in
            switch output {
            case .toExternal(let value):
                return .set(value)
            case .toInternal, .toReducer:
                return .set()
            }
        }
        
        return out
    }
}

public enum ControllerResult<InternalOutput, ExternalOutput> {
    case int(InternalOutput)
    case ext(ExternalOutput)
}
