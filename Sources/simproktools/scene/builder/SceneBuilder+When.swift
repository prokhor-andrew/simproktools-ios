//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate


public extension SceneBuilder {
    
    func when(
            _ function: @escaping (Trigger) -> [Effect]?
    ) -> SceneBuilder<Trigger, Effect> {
        handle { state in
            Scene.create {
                if let effects = function($0) {
                    return SceneTransition(
                        state,
                        effects: effects
                    )
                } else {
                    return nil
                }
            }
        }
    }
}


public extension SceneBuilder where Trigger: Equatable {
    
    func when(
            is trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when { 
            if $0 == trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    func when(
            is trigger: Trigger,
            send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(is: trigger, send: effects)
    }

    func when(
            not trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when {
            if $0 != trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    func when(
            not trigger: Trigger,
            send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(not: trigger, send: effects)
    }
}
