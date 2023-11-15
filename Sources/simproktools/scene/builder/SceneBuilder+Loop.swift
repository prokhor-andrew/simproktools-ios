//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate


public extension SceneBuilder {
    
    func loop(
            _ function: @escaping (Trigger) -> (Bool, [Effect])
    ) -> SceneBuilder<Trigger, Effect> {
        handle { state in
            
            @Sendable
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
