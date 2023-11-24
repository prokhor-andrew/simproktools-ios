//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokstate


public extension Feature {

    static func never() -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature.create(SetOfMachines()) { _, _ in FeatureTransition(never()) }
    }
}
