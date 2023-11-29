//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public extension Feature {

    static func never(doOn: @escaping ((Loggable) -> Void) -> Void = { _ in }) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature.create(SetOfMachines()) { extras, _ in
            doOn(extras.logger)
            return FeatureTransition(never(doOn: doOn))
        }
    }
}
