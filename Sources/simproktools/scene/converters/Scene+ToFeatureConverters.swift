//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    func asExtTriggerExtEffect<IntTrigger, IntEffect>() -> Feature<IntTrigger, IntEffect, Trigger, Effect> {
        if let transit {
            let feature: Feature<IntTrigger, IntEffect, Trigger, Effect> = Feature.create(SetOfMachines()) { _, event in
                switch event {
                case .ext(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asExtTriggerExtEffect(),
                            effects: new.effects.map {
                                .ext($0)
                            }
                    )
                case .int:
                    return FeatureTransition(feature)
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntEffectExtTrigger<ExtEffect, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Machines.Trigger, Effect, Trigger, ExtEffect> where Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Machines.Trigger, Effect, Trigger, ExtEffect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asIntEffectExtTrigger(machines),
                            effects: new.effects.map {
                                .int($0)
                            }
                    )
                case .int:
                    return FeatureTransition(feature)
                }
            }
            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerExtEffect<ExtTrigger, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Trigger, Machines.Effect, ExtTrigger, Effect> where Machines.Trigger == Trigger {
        if let transit {
            let feature: Feature<Trigger, Machines.Effect, ExtTrigger, Effect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext:
                    return FeatureTransition(feature)
                case .int(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asIntTriggerExtEffect(machines),
                            effects: new.effects.map {
                                .ext($0)
                            }
                    )

                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffect<ExtTrigger, ExtEffect, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Trigger, Effect, ExtTrigger, ExtEffect> where Machines.Trigger == Trigger, Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Trigger, Effect, ExtTrigger, ExtEffect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext:
                    return FeatureTransition(feature)
                case .int(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asIntTriggerIntEffect(machines),
                            effects: new.effects.map {
                                .int($0)
                            }
                    )
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }


    func asIntEffectExtTriggerExtEffect<Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Machines.Trigger, Effect, Trigger, Effect> where Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Machines.Trigger, Effect, Trigger, Effect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value):

                    let new = transit(value)

                    return FeatureTransition(
                            new.state.asIntEffectExtTriggerExtEffect(machines),
                            effects: new.effects.flatMap {
                                [.int($0), .ext($0)]
                            }
                    )
                case .int:
                    return FeatureTransition(feature)
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffectExtEffect<ExtTrigger, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Trigger, Effect, ExtTrigger, Effect> where Machines.Trigger == Trigger, Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Trigger, Effect, ExtTrigger, Effect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext:
                    return FeatureTransition(feature)
                case .int(let value):
                    let new = transit(value)

                    return FeatureTransition(
                            new.state.asIntTriggerIntEffectExtEffect(machines),
                            effects: new.effects.flatMap {
                                [.int($0), .ext($0)]
                            }
                    )
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffectExtTrigger<ExtEffect, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Trigger, Effect, Trigger, ExtEffect> where Machines.Trigger == Trigger, Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Trigger, Effect, Trigger, ExtEffect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asIntTriggerIntEffectExtTrigger(machines),
                            effects: new.effects.map {
                                .int($0)
                            }
                    )
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerExtTriggerExtEffect<Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Trigger, Machines.Effect, Trigger, Effect> where Machines.Trigger == Trigger, Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Trigger, Machines.Effect, Trigger, Effect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asIntTriggerExtTriggerExtEffect(machines),
                            effects: new.effects.map {
                                .ext($0)
                            }
                    )
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffectExtTriggerExtEffect<Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Trigger, Effect, Trigger, Effect> where Machines.Trigger == Trigger, Machines.Effect == Effect {
        if let transit {
            let feature: Feature<Trigger, Effect, Trigger, Effect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    let new = transit(value)
                    return FeatureTransition(
                            new.state.asIntTriggerIntEffectExtTriggerExtEffect(machines),
                            effects: new.effects.flatMap {
                                [.int($0), .ext($0)]
                            }
                    )
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }
}