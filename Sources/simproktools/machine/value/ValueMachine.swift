//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine where Input == Output {

    static func value(doOn: @escaping (Input, String, (Loggable) -> Void) -> Void = { _,_,_ in }) -> Machine<Input, Output> {
        .pure { input, callback, id, logger in
            doOn(input, id, logger)
            await callback(input)
        }
    }
}
