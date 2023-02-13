//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine where Input == Output {

    static func valueNoNil() -> Machine<Input, Output> {
        Machine { input, callback in
            if let input = input {
                callback(input)
            }
        }
    }
}


public extension Machine where Input? == Output {

    static func valueWithNil() -> Machine<Input, Output> {
        Machine { input, callback in
            callback(input)
        }
    }
}