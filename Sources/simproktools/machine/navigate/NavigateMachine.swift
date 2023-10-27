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
        _ outline: Outline<Output, Input, RInput, ROutput>
    ) -> Machine<RInput, ROutput> {
        Machine<RInput, ROutput> {
            outline.asFeature(SetOfMachines(self))
        }
    }
}
