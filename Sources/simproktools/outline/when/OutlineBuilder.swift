//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate


public struct OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {

    private let featureSupplier: Mapper<Mapper<FeatureEvent<IntTrigger, ExtTrigger>, OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>?>, Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>

    public init() {
        featureSupplier = Outline.create
    }

    private init(_ featureSupplier: @escaping Mapper<Mapper<FeatureEvent<IntTrigger, ExtTrigger>, OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>?>, Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>) {
        self.featureSupplier = featureSupplier
    }

    public func when(
            _ function: @escaping Mapper<FeatureEvent<IntTrigger, ExtTrigger>, [FeatureEvent<IntEffect, ExtEffect>]?>
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> { transit in
            featureSupplier {
                if let effects = function($0) {
                    return OutlineTransition(
                            Outline.create(transit: transit),
                            effects: effects
                    )
                } else {
                    return nil
                }
            }
        }
    }

    public func when(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        when { event in
            if event == trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    public func when(
            is trigger:  FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        when(is: trigger, send: effects)
    }

    public func when(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        when { event in
            if event != trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    public func when(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        when(not: trigger, send: effects)
    }

    public func loop(
            _ function: @escaping Mapper<FeatureEvent<IntTrigger, ExtTrigger>, OutlineLoop<IntEffect, ExtEffect>>
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        OutlineBuilder { mapper in
            let outline: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> = featureSupplier {
                switch function($0) {
                case .loop(let effects):
                    return OutlineTransition(outline, effects: effects)
                case .exit(let effects):
                    return OutlineTransition(Outline.create(transit: mapper), effects: effects)
                }
            }

            return outline
        }
    }

    public func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop {
            if $0 == trigger {
                return .exit(loopEffects)
            } else {
                return .loop(exitEffects)
            }
        }
    }

    public func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop {
            if $0 != trigger {
                return .exit(loopEffects)
            } else {
                return .loop(exitEffects)
            }
        }
    }

    public func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    public func then(
            _ function: @escaping Mapper<FeatureEvent<IntTrigger, ExtTrigger>, OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>?>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        featureSupplier { event in
            if let transition = function(event) {
                return transition
            } else {
                return nil
            }
        }
    }

    public func then(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            execute transition: @autoclosure @escaping Supplier<OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        then { event in
            if event == trigger {
                return transition()
            } else {
                return nil
            }
        }
    }

    public func then(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            execute transition: @autoclosure @escaping Supplier<OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        then { event in
            if event != trigger {
                return transition()
            } else {
                return nil
            }
        }
    }
}
