//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func never(doOn: @escaping (Input, String, (Loggable) -> Void) -> Void = { _,_,_ in }) -> Machine<Input, Output> {
        .pure { input, _, id, logger  in
            doOn(input, id, logger)
        }
    }
}
