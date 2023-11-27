//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokstate


public extension Feature {

    static func never(doOn: @escaping ((Message) -> Void) -> Void = { _ in }) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        Feature.create(SetOfMachines()) { _, _, logger in
            doOn(logger)
            return FeatureTransition(never(doOn: doOn))
        }
    }
}
