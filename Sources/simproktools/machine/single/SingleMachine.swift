//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func single(_ value: Output) -> Machine<Input, Output> {
        Machine { input, callback in
            if input == nil {
                callback(value)
            }
        }
    }
}