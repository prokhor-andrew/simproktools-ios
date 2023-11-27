//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokstate


public extension Feature {

    static func never(doOn: @escaping ((String) -> Void) -> Void = { _ in }) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature.create(SetOfMachines()) { _, _, logger in
            doOn(logger)
            return FeatureTransition(never(doOn: doOn))
        }
    }
}
