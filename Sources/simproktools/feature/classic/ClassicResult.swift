//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate


public struct ClassicResult<State: FeatureMachines, IntTrigger, IntEffect, ExtTrigger, ExtEffect> {

    public let state: State
    public let effects: [FeatureEvent<IntEffect, ExtEffect>]

    public init(
            _ state: State,
            effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) {
        self.state = state
        self.effects = effects
    }

    public init(
            _ state: State,
            effects: FeatureEvent<IntEffect, ExtEffect>...
    ) {
        self.init(state, effects: effects)
    }
}
