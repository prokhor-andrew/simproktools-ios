//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate



public extension Scene {
    
    
    func switchOnFinale(to scene: Scene<Trigger, Effect>) -> Scene<Trigger, Effect> {
        guard let transit else {
            return .finale()
        }
      
        return Scene.create { trigger in
            if let transition = transit(trigger) {
                if transition.state.isFinale {
                    return SceneTransition(
                        scene,
                        effects: transition.effects
                    )
                } else {
                    return SceneTransition(
                        transition.state.switchOnFinale(to: scene),
                        effects: transition.effects
                    )
                }
            } else {
                return nil
            }
        }
    }
}
