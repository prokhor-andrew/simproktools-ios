//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 08.04.2023.
//

import simprokmachine
import simprokstate


public extension Scene {
    
    func switchTo(
        doneOnFinale: Bool = true,
        function: @escaping (Scene<Trigger, Effect>, Trigger) -> SceneTransition<Trigger, Effect>?
    ) -> Scene<Trigger, Effect> {
        if doneOnFinale {
            if let transit {
                return Scene.create { trigger in
                    if let transition = function(self, trigger) {
                        return transition
                    } else {
                        if let transition = transit(trigger) {
                            return SceneTransition(
                                transition.state.switchTo(doneOnFinale: doneOnFinale, function: function),
                                effects: transition.effects
                            )
                        } else {
                            return nil
                        }
                    }
                }
            } else {
                return .finale()
            }
        } else {
            return Scene.create { trigger in
                if let transition = function(self, trigger) {
                    return transition
                } else {
                    if let transit, let transition = transit(trigger) {
                        return SceneTransition(
                            transition.state.switchTo(doneOnFinale: doneOnFinale, function: function),
                            effects: transition.effects
                        )
                    } else {
                        return nil
                    }
                }
            }
        }
    }
}
