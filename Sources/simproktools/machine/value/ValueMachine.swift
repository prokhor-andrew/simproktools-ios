//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine where Input == Output {

    static func value() -> Machine<Input, Output> {
        .pure { input, callback in
            await callback(input)
        }
    }
}
