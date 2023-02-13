//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    static func never() -> Machine<Input, Output> {
        Machine { _, _ in

        }
    }
}
