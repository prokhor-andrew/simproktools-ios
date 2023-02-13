//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine
import simprokstate


public struct ClassicResultWithPayload<Payload, Machines: FeatureMachines, IntTrigger, IntEffect, ExtTrigger, ExtEffect> {

    public let payload: Payload
    public let machines: Machines
    public let effects: [FeatureEvent<IntEffect, ExtEffect>]

    public init(
            _ payload: Payload,
            machines: Machines,
            effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) {
        self.payload = payload
        self.machines = machines
        self.effects = effects
    }

    public init(
            _ payload: Payload,
            machines: Machines,
            effects: FeatureEvent<IntEffect, ExtEffect>...
    ) {
        self.init(payload, machines: machines, effects: effects)
    }
}
