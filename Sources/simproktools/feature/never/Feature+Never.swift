//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public extension Feature {

    static func never() -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature { _ in
            FeatureTransition(.never())
        }
    }
}
