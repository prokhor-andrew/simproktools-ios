//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate

public extension OutlineBuilder {
    
    func loop(
            _ function: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> (Bool, [FeatureEvent<IntEffect, ExtEffect>])
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        handle { state in
            @Sendable
            func provide() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
                Outline.create {
                    let (isLoop, effects) = function($0)
                    
                    if isLoop {
                        return OutlineTransition(
                            provide(),
                            effects: effects
                        )
                    } else {
                        return OutlineTransition(
                            state,
                            effects: effects
                        )
                    }
                }
            }
            
            return provide()
        }
    }
}

public extension OutlineBuilder where IntTrigger: Equatable, ExtTrigger: Equatable {
 
    func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop {
            if $0 == trigger {
                return (true, loopEffects)
            } else {
                return (false, exitEffects)
            }
        }
    }

    func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop {
            if $0 != trigger {
                return (true, loopEffects)
            } else {
                return (false, exitEffects)
            }
        }
    }

    func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: [FeatureEvent<IntEffect, ExtEffect>],
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send loopEffects: FeatureEvent<IntEffect, ExtEffect>...,
            exit exitEffects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where IntTrigger: Equatable, ExtTrigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }
}
