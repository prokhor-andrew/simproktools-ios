//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public extension Feature {

    static func never(
        doOnTrigger: @escaping (FeatureExtras<SetOfMachines<IntTrigger, IntEffect>>, FeatureEvent<IntTrigger, ExtTrigger>) -> Void = { _,_ in }
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature.create(SetOfMachines()) {
            doOnTrigger($0, $1)
            return FeatureTransition(never(doOnTrigger: doOnTrigger))
        }
    }
}
