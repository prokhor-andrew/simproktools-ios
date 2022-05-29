//
//  ScanMachine.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.

import simprokmachine


public extension MachineType {
    /// Takes `self` and applies specific behavior.
    /// When parent machine sends new input, it is either reduced into new child state and sent to the `self` or mapped into parent output and emitted back.
    /// When child machine sends new output, it is either reduced into new child state and sent back to the `self` or mapped into parent output and emitted.
    /// - parameter initial: initial state that is sent to the `self` machine when subscribed.
    /// - parameter reducer: `BiMapper` that accepts current state as `Input`, new input as `ScanInput`, and returns `ScanOutput`.
    func scan<ParentInput, ParentOutput>(
        _ initial: Input,
        reducer: @escaping BiMapper<Input, ScanInput<ParentInput, Output>, ScanOutput<ParentOutput, Input>>
    ) -> Machine<ParentInput, ParentOutput> {
        let machine: Machine<
            ScanEmit<ParentInput, ParentOutput, Input, Output>,
            ScanEmit<ParentInput, ParentOutput, Input, Output>
        > = outward { .set(.toReducer(.inner($0))) }.inward { input in
            switch input {
            case .toMachine(let input):
                return .set(input)
            case .out, .toReducer:
                return .set()
            }
        }

        let reducer: Machine<
            ScanEmit<ParentInput, ParentOutput, Input, Output>,
            ScanEmit<ParentInput, ParentOutput, Input, Output>
        > = ClassicMachine<
            Input,
            ScanInput<ParentInput, Output>,
            ScanEmit<ParentInput, ParentOutput, Input, Output>
        >(.set(initial, outputs: .toMachine(initial))) {
            switch reducer($0, $1) {
            case .state(let input):
                return .set(input, outputs: .toMachine(input))
            case .event(let output):
                return .set($0, outputs: .out(output))
            }
        }.inward {
            switch $0 {
            case .toMachine, .out:
                return .set()
            case .toReducer(let input):
                return .set(input)
            }
        }
        
        let result: Machine<ParentInput, ParentOutput> = Machine.merge(machine, reducer).redirect {
            switch $0 {
            case .toMachine, .toReducer:
                return .back($0)
            case .out:
                return .prop
            }
        }.outward {
            switch $0 {
            case .toMachine, .toReducer:
                return .set()
            case .out(let output):
                return .set(output)
            }
        }.inward { .set(.toReducer(.outer($0))) }
        
        return result
    }
}
