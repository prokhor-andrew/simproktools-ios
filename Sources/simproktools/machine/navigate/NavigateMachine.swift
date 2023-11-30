//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 27.10.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    func navigate<RInput, ROutput>(
        _ outline: @autoclosure @escaping () -> Outline<Output, Input, RInput, ROutput>
    ) -> Machine<RInput, ROutput> {
        Machine<RInput, ROutput> { machineId in
            outline().asFeature(SetOfMachines(self))
        }
    }
}

