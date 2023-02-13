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
                                return ClassicResult(machines, effects: .int(input))
                            case .int(let output):
                                return ClassicResult(machines, effects: .ext(output))
                            }
                        }
                )
        )
    }

    static func merge(_ machines: Machine<Input, Output>...) -> Machine<Input, Output> {
        merge(Set(machines))
    }
}