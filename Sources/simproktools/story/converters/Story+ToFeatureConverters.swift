//
// Created by Andriy Prokhorenko on 14.02.2023.
//

import simprokstate

public extension Story {

    func asExtTriggerExtEffect<IntTrigger, IntEffect>() -> Feature<IntTrigger, IntEffect, Event, Event> {
        if let transit {
            let feature: Feature<IntTrigger, IntEffect, Event, Event> = Feature.create(SetOfMachines()) { _, event in
                switch event {
                case .ext(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asExtTriggerExtEffect(),
                                effects: .ext(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
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
    ) -> Feature<Machines.Trigger, Event, Event, ExtEffect> where Machines.Effect == Event {
        if let transit {
            let feature: Feature<Machines.Trigger, Event, Event, ExtEffect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntEffectExtTrigger(machines),
                                effects: .int(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
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
    ) -> Feature<Event, Machines.Effect, ExtTrigger, Event> where Machines.Trigger == Event {
        if let transit {
            let feature: Feature<Event, Machines.Effect, ExtTrigger, Event> = Feature.create(machines) { machines, event in
                switch event {
                case .ext:
                    return FeatureTransition(feature)
                case .int(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntTriggerExtEffect(machines),
                                effects: .ext(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffect<ExtTrigger, ExtEffect, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Event, Event, ExtTrigger, ExtEffect> where Machines.Trigger == Event, Machines.Effect == Event {
        if let transit {
            let feature: Feature<Event, Event, ExtTrigger, ExtEffect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext:
                    return FeatureTransition(feature)
                case .int(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntTriggerIntEffect(machines),
                                effects: .int(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntEffectExtTriggerExtEffect<Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Machines.Trigger, Event, Event, Event> where Machines.Effect == Event {
        if let transit {
            let feature: Feature<Machines.Trigger, Event, Event, Event> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntEffectExtTriggerExtEffect(machines),
                                effects: .int(value), .ext(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
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
    ) -> Feature<Event, Event, ExtTrigger, Event> where Machines.Trigger == Event, Machines.Effect == Event {
        if let transit {
            let feature: Feature<Event, Event, ExtTrigger, Event> = Feature.create(machines) { machines, event in
                switch event {
                case .ext:
                    return FeatureTransition(feature)
                case .int(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntTriggerIntEffectExtEffect(machines),
                                effects: .int(value), .ext(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffectExtTrigger<ExtEffect, Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Event, Event, Event, ExtEffect> where Machines.Trigger == Event, Machines.Effect == Event {
        if let transit {
            let feature: Feature<Event, Event, Event, ExtEffect> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntTriggerIntEffectExtTrigger(machines),
                                effects: .int(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerExtTriggerExtEffect<Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Event, Machines.Effect, Event, Event> where Machines.Trigger == Event, Machines.Effect == Event {
        if let transit {
            let feature: Feature<Event, Machines.Effect, Event, Event> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntTriggerExtTriggerExtEffect(machines),
                                effects: .ext(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }

    func asIntTriggerIntEffectExtTriggerExtEffect<Machines: FeatureMachines>(
            _ machines: Machines
    ) -> Feature<Event, Event, Event, Event> where Machines.Trigger == Event, Machines.Effect == Event {
        if let transit {
            let feature: Feature<Event, Machines.Effect, Event, Event> = Feature.create(machines) { machines, event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    if let new = transit(value) {
                        return FeatureTransition(
                                new.asIntTriggerIntEffectExtTriggerExtEffect(machines),
                                effects: .int(value), .ext(value)
                        )
                    } else {
                        return FeatureTransition(feature)
                    }
                }
            }

            return feature
        } else {
            return .finale(SetOfMachines())
        }
    }
}