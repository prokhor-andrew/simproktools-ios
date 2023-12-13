//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func never(doOnTrigger: @escaping (Input, String, MachineLogger) -> Void = { _,_,_ in }) -> Machine<Input, Output> {
        .pure { input, _, id, logger  in
            doOnTrigger(input, id, logger)
        }
    }
}
