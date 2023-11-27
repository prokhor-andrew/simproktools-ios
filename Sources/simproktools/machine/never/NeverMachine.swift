//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func never(doOn: @escaping ((Message) -> Void) -> Void = { _ in }) -> Machine<Input, Output, Message> {
        .pure { _, _, logger  in
            doOn(logger)
        }
    }
}
