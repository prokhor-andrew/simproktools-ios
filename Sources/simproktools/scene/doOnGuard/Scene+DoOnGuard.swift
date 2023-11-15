//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokstate


public extension Scene {
    
    func doOnGuard(function: @escaping @Sendable (Trigger) -> Void) -> Scene<Trigger, Effect> {
        if let transit {
            return Scene.create { trigger in
                if let transition = transit(trigger) {
                    return SceneTransition(
                        transition.state.doOnGuard(function: function),
                        effects: transition.effects
                    )
                } else {
                    function(trigger)
                    return nil
                }
            }
        } else {
            return Scene.finale()
        }
    }
}
