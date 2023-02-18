//
// Created by Andriy Prokhorenko on 10.02.2023.
//

import simprokmachine
import simprokstate

public struct FeatureBuilder<Machines: FeatureMachines, ExtTrigger, ExtEffect> {

    private let featureSupplier: Mapper<BiMapper<Machines, FeatureEvent<Machines.Trigger, ExtTrigger>, FeatureTransition<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>>, Feature<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>>

    public init(
            _ machines: @autoclosure @escaping Supplier<Machines>
    ) {
        featureSupplier = {
            Feature.create(machines(), transit: $0)
        }
    }

    private init(_ featureSupplier: @escaping Mapper<BiMapper<Machines, FeatureEvent<Machines.Trigger, ExtTrigger>, FeatureTransition<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>>, Feature<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>>) {
        self.featureSupplier = featureSupplier
    }

    public func when<NewMachines: FeatureMachines>(
            _ function: @escaping BiMapper<Machines, FeatureEvent<Machines.Trigger, ExtTrigger>, BuilderTransition<NewMachines, ExtEffect>?>
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect {
        FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> { transit in

            let feature = featureSupplier {
                if let transition = function($0, $1) {
                    return FeatureTransition(
                            Feature.create(transition.machines, transit: transit),
                            effects: transition.effects
                    )
                } else {
                    return FeatureTransition(feature)
                }
            }

            return feature
        }
    }

    public func when<NewMachines: FeatureMachines>(
            is trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            execute transition: @escaping Mapper<Machines, BuilderTransition<NewMachines, ExtEffect>>
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect, Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when { machines, event in
            if event == trigger {
                return transition(machines)
            } else {
                return nil
            }
        }
    }

    public func when<NewMachines: FeatureMachines>(
            not trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            execute transition: @escaping Mapper<Machines, BuilderTransition<NewMachines, ExtEffect>>
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect, Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when { machines, event in
            if event != trigger {
                return transition(machines)
            } else {
                return nil
            }
        }
    }

    // when is-send
    public func when(
            is trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            send effects: [FeatureEvent<Machines.Effect, ExtEffect>]
    ) -> FeatureBuilder<Machines, ExtTrigger, ExtEffect> where Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when { machines, event in
            if event == trigger {
                return BuilderTransition(machines, effects: effects)
            } else {
                return nil
            }
        }
    }

    public func when(
            is trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            send effects: FeatureEvent<Machines.Effect, ExtEffect>...
    ) -> FeatureBuilder<Machines, ExtTrigger, ExtEffect> where Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when(is: trigger, send: effects)
    }

    // when not-send
    public func when(
            not trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            send effects: [FeatureEvent<Machines.Effect, ExtEffect>]
    ) -> FeatureBuilder<Machines, ExtTrigger, ExtEffect> where Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when { machines, event in
            if event != trigger {
                return BuilderTransition(machines, effects: effects)
            } else {
                return nil
            }
        }
    }

    public func when(
            not trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            send effects: FeatureEvent<Machines.Effect, ExtEffect>...
    ) -> FeatureBuilder<Machines, ExtTrigger, ExtEffect> where Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when(not: trigger, send: effects)
    }

    // when is-set-send
    public func when<NewMachines: FeatureMachines>(
            is trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            set machines: @autoclosure @escaping Supplier<NewMachines>,
            send effects: [FeatureEvent<Machines.Effect, ExtEffect>]
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect, Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when(is: trigger) { _ in
            BuilderTransition(machines(), effects: effects)
        }
    }

    public func when<NewMachines: FeatureMachines>(
            is trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            set machines: @autoclosure @escaping Supplier<NewMachines>,
            send effects: FeatureEvent<Machines.Effect, ExtEffect>...
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect, Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when(is: trigger, set: machines(), send: effects)
    }


    // when not-set-send
    public func when<NewMachines: FeatureMachines>(
            not trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            set machines: @autoclosure @escaping Supplier<NewMachines>,
            send effects: [FeatureEvent<Machines.Effect, ExtEffect>]
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect, Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when(not: trigger) { _ in
            BuilderTransition(machines(), effects: effects)
        }
    }

    public func when<NewMachines: FeatureMachines>(
            not trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            set machines: @autoclosure @escaping Supplier<NewMachines>,
            send effects: FeatureEvent<Machines.Effect, ExtEffect>...
    ) -> FeatureBuilder<NewMachines, ExtTrigger, ExtEffect> where NewMachines.Trigger == Machines.Trigger, NewMachines.Effect == Machines.Effect, Machines.Trigger: Equatable, ExtTrigger: Equatable {
        when(not: trigger, set: machines(), send: effects)
    }

    public func then(
            _ function: @escaping BiMapper<Machines, FeatureEvent<Machines.Trigger, ExtTrigger>, FeatureTransition<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>?>
    ) -> Feature<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect> {
        let feature = featureSupplier { machines, event in
            if let transition = function(machines, event) {
                return transition
            } else {
                return FeatureTransition(feature)
            }
        }

        return feature
    }

    public func then(
            is trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            execute transition: @autoclosure @escaping Supplier<FeatureTransition<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>>
    ) -> Feature<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect> where Machines.Trigger: Equatable, ExtTrigger: Equatable {
        then { machines, event in
            if event == trigger {
                return transition()
            } else {
                return nil
            }
        }
    }

    public func then(
            not trigger: FeatureEvent<Machines.Trigger, ExtTrigger>,
            execute transition: @autoclosure @escaping Supplier<FeatureTransition<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect>>
    ) -> Feature<Machines.Trigger, Machines.Effect, ExtTrigger, ExtEffect> where Machines.Trigger: Equatable, ExtTrigger: Equatable {
        then { machines, event in
            if event != trigger {
                return transition()
            } else {
                return nil
            }
        }
    }
}