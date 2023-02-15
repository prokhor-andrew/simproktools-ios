//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokstate

public struct ClassicFeatureResult<State: FeatureMachines, IntTrigger, IntEffect, ExtTrigger, ExtEffect> {

    public let state: State
    public let info: String
    public let effects: [FeatureEvent<IntEffect, ExtEffect>]

    public init(
            _ state: State,
            info: String = "",
            effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) {
        self.state = state
        self.info = info
        self.effects = effects
    }

    public init(
            _ state: State,
            info: String = "",
            effects: FeatureEvent<IntEffect, ExtEffect>...
    ) {
        self.init(state, info: info, effects: effects)
    }
}
