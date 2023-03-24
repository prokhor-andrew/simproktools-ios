//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate

public extension Machine {

    static func merge(_ machines: Set<Machine<Input, Output>>) -> Machine<Input, Output> {
        Machine(
                FeatureTransition(
                        Feature.classic(SetOfMachines(machines)) { machines, trigger in
                            switch trigger {
                            case .ext(let input):
                                return (machines, effects: [.int(input)], false)
                            case .int(let output):
                                return (machines, effects: [.ext(output)], false)
                            }
                        }
                )
        )
    }

    static func merge(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
        merge(Set(machines))
    }


    func and(_ machines: Set<Machine<Input, Output>>) -> Machine<Input, Output> {
        Machine.merge(machines.union([self]))
    }

    func and(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
        and(Set(machines))
    }
}
