//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func never(doOn: @escaping (Input, (Loggable) -> Void) -> Void = { _,_ in }) -> Machine<Input, Output> {
        .pure { input, _, logger  in
            doOn(input, logger)
        }
    }
}
