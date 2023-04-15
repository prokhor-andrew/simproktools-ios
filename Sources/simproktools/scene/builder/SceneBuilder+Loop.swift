//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate


public extension SceneBuilder {
    
    func loop(
            _ function: @escaping Mapper<Trigger, (Bool, [Effect])>
    ) -> SceneBuilder<Trigger, Effect> {
        handle { state in
            func provide() -> Scene<Trigger, Effect> {
                Scene.create {
                    let (isLoop, effects) = function($0)
                    if isLoop {
                        return SceneTransition(
                            state,
                            effects: effects
                        )
                    } else {
                        return SceneTransition(
                            provide(),
                            effects: effects
                        )
                    }
                }
            }
            
            return provide()
        }
    }
}


public extension SceneBuilder where Trigger: Equatable {
    
    func loop(
           is trigger: Trigger,
           send loopEffects: [Effect],
           exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        loop {
           if $0 == trigger {
               return (false, loopEffects)
           } else {
               return (true, exitEffects)
           }
       }
    }

    func loop(
            is trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            is trigger: Trigger,
            send loopEffects: [Effect],
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            is trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            not trigger: Trigger,
            send loopEffects: [Effect],
            exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        loop {
            if $0 != trigger {
                return (false, loopEffects)
            } else {
                return (true, exitEffects)
            }
        }
    }

    func loop(
            not trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            not trigger: Trigger,
            send loopEffects: [Effect],
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    func loop(
            not trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }
}
