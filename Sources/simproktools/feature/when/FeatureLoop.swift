//
// Created by Andriy Prokhorenko on 18.02.2023.
//

import simprokstate

public enum FeatureLoop<Machines: FeatureMachines, ExtEffect> {
    case loop([FeatureEvent<Machines.Effect, ExtEffect>])
    case exit(Machines, effects: [FeatureEvent<Machines.Effect, ExtEffect>])
}
