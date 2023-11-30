//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func merge(_ machines: @escaping @autoclosure () -> Set<Machine<Input, Output>>) -> Machine<Input, Output> {
        Machine {
            Feature.classic(SetOfMachines(machines())) { extras, trigger in
                switch trigger {
                case .ext(let input):
                    return (extras.machines, effects: [.int(input)])
                case .int(let output):
                    return (extras.machines, effects: [.ext(output)])
                }
            }
        }
    }

    static func merge(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
        merge(Set(machines))
    }


    func and(_ machines: @escaping @autoclosure () -> Set<Machine<Input, Output>>) -> Machine<Input, Output> {
        Machine.merge(machines().union([self]))
    }

    func and(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
        and(Set(machines))
    }
}
