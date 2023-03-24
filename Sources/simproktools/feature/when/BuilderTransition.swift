//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokstate

public struct BuilderTransition<Machines: FeatureMachines, ExtEffect> {

    public let machines: Machines
    public let effects:  [FeatureEvent<Machines.Effect, ExtEffect>]

    public init(
            _ machines: Machines,
            effects: [FeatureEvent<Machines.Effect, ExtEffect>]
    ) {
        self.machines = machines
        self.effects = effects
    }

    public init(
            _ machines: Machines,
            effects: FeatureEvent<Machines.Effect, ExtEffect>...
    ) {
        self.init(machines, effects: effects)
    }
}
