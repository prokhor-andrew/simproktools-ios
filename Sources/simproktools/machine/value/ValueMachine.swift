//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine where Input == Output {

    static func value(doOn: @escaping ((Message) -> Void) -> Void = { _ in }) -> Machine<Input, Output, Message> {
        .pure { input, callback, logger in
            doOn(logger)
            await callback(input)
        }
    }
}
