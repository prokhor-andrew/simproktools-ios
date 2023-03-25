//
// Created by Andriy Prokhorenko on 18.02.2023.
//

import simprokstate

public enum FeatureLoop<LoopMachines: FeatureMachines, ExitMachines: FeatureMachines, ExtEffect> {
    case loop(LoopMachines, effects: [FeatureEvent<LoopMachines.Effect, ExtEffect>])
    case exit(ExitMachines, effects: [FeatureEvent<ExitMachines.Effect, ExtEffect>])
}
