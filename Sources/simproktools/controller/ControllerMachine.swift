//
//  ControllerMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public func controller<M: MachineType, State, InternalInput, ExternalInput, InternalOutput, ExternalOutput>(
    _ machine: M,
    initial state: ClassicResult<State, ControllerEvent<InternalOutput, ExternalOutput>>,
    function: @escaping BiMapper<State, ControllerEvent<InternalInput, ExternalInput>, ClassicResult<State, ControllerEvent<InternalOutput, ExternalOutput>>>
) -> Machine<ExternalInput, ExternalOutput> where M.Output == InternalInput, M.Input == InternalOutput {
    Machine.controller(machine, initial: state, function: function)
}

public extension MachineType {

    static func controller<M: MachineType, State, InternalInput, ExternalInput, InternalOutput, ExternalOutput>(
        _ machine: M,
        initial state: ClassicResult<State, ControllerEvent<InternalOutput, ExternalOutput>>,
        function: @escaping BiMapper<State, ControllerEvent<InternalInput, ExternalInput>, ClassicResult<State, ControllerEvent<InternalOutput, ExternalOutput>>>
    ) -> Machine<ExternalInput, ExternalOutput> where M.Output == InternalInput, M.Input == InternalOutput, ExternalInput == Input, ExternalOutput == Output {
        machine.controller(state, function: function)
    }

    func controller<State, InternalInput, ExternalInput, InternalOutput, ExternalOutput>(
        _ state: ClassicResult<State, ControllerEvent<InternalOutput, ExternalOutput>>,
        function: @escaping BiMapper<State, ControllerEvent<InternalInput, ExternalInput>, ClassicResult<State, ControllerEvent<InternalOutput, ExternalOutput>>>
    ) -> Machine<ExternalInput, ExternalOutput> where Output == InternalInput, Input == InternalOutput {
        let filter: Machine<
            InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput>,
            InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput>
        >
        = Machine.classic(state) { state, event in
            function(state, event)
        }.inward { input in
            switch input {
            case .toReducer(let value):
                return [value]
            case .toInternal, .toExternal:
                return []
            }
        }.outward { result in
            switch result {
            case .ext(let ext):
                return [InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput>.toExternal(ext)]
            case .int(let int):
                return [InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput>.toInternal(int)]
            }
        }
        

        let int: Machine<
            InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput>,
            InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput>
        > = inward { input in
            switch input {
            case .toInternal(let value):
                return [value]
            case .toReducer, .toExternal:
                return []
            }
        }.outward { event in
            [.toReducer(.int(event))]
        }

        let out: Machine<ExternalInput, ExternalOutput> = Machine.merge(
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
            [.toReducer(.ext(input))]
        }.outward { output in
            switch output {
            case .toExternal(let value):
                return [value]
            case .toInternal, .toReducer:
                return []
            }
        }

        return out
    }
}


internal enum InternalControllerEvent<InternalInput, ExternalInput, InternalOutput, ExternalOutput> {
    case toReducer(ControllerEvent<InternalInput, ExternalInput>)
    case toInternal(InternalOutput)
    case toExternal(ExternalOutput)
}
