//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func just(_ value: Output, sendInitial: Bool = false) -> Machine<Input, Output> {
        Machine { input, callback in
            if input == nil && !sendInitial {
                return
            }

            callback(value)
        }
    }
}
