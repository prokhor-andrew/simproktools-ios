//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine where Input == Output {

    static func value(doOnTrigger: @escaping (Input, String, (Loggable) -> Void) -> Void = { _,_,_ in }) -> Machine<Input, Output> {
        .pure { input, callback, id, logger in
            doOnTrigger(input, id, logger)
            await callback(input)
        }
    }
}
