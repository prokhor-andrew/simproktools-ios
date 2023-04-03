//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Scene {
    
    
    func switchOnTransition(
        to scene: Scene<Trigger, Effect>
    ) -> Scene<Trigger, Effect> {
        if let sceneTransit = scene.transit {
            return Scene.create { trigger in
                if let transition = sceneTransit(trigger) {
                    return transition
                } else {
                    if let transit {
                        if let transition = transit(trigger) {
                            return SceneTransition(
                                transition.state.switchOnTransition(to: scene),
                                effects: transition.effects
                            )
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
            }
        } else {
            return self
        }
    }
    
    
    func switchOnTransition(
        from scene: Scene<Trigger, Effect>
    ) -> Scene<Trigger, Effect> {
        scene.switchOnTransition(to: self)
    }
}

