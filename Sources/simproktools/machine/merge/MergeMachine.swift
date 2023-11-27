//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func merge(_ machines: @escaping @autoclosure () -> Set<Machine<Input, Output, Message>>) -> Machine<Input, Output, Message> {
        Machine {
            Feature.classic(SetOfMachines(machines())) { machines, trigger, logger in
                switch trigger {
                case .ext(let input):
                    return (machines, effects: [.int(input)])
                case .int(let output):
                    return (machines, effects: [.ext(output)])
                }
            }
        }
    }

    static func merge(_ machines: Machine<Input, Output, Message>...) -> Machine<Input, Output, Message> {
        merge(Set(machines))
    }


    func and(_ machines: @escaping @autoclosure () -> Set<Machine<Input, Output, Message>>) -> Machine<Input, Output, Message> {
        Machine.merge(machines().union([self]))
    }

    func and(_ machines: Machine<Input, Output, Message>...) -> Machine<Input, Output, Message> {
        and(Set(machines))
    }
}
