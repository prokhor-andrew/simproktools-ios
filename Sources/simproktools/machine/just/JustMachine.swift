//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func just(_ value: Output) -> Machine<Input, Output> {
        Machine { _, callback in
            callback(value)
        }
    }
}
