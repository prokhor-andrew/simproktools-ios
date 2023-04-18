//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Scene {
    
    
    func switchOnTransition(
        to scene: Scene<Trigger, Effect>,
        doneOnFinale: Bool = true
    ) -> Scene<Trigger, Effect> {
        if doneOnFinale {
            if let transit {
                if let sceneTransit = scene.transit {
                    return Scene.create { trigger in
                        if let transition = sceneTransit(trigger) {
                            return transition
                        } else {
                            if let transition = transit(trigger) {
                                return SceneTransition(
                                    transition.state.switchOnTransition(to: scene, doneOnFinale: doneOnFinale),
                                    effects: transition.effects
                                )
                            } else {
                                return nil
                            }
                        }
                    }
                } else {
                    return self
                }
            } else {
                return .finale()
            }
        } else {
            if let sceneTransit = scene.transit {
                return Scene.create { trigger in
                    if let transition = sceneTransit(trigger) {
                        return transition
                    } else {
                        if let transit {
                            if let transition = transit(trigger) {
                                return SceneTransition(
                                    transition.state.switchOnTransition(to: scene, doneOnFinale: doneOnFinale),
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
    }
}

