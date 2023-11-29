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
        _ function: @escaping (Trigger, (Loggable) -> Void) -> (Bool, [Effect])
    ) -> SceneBuilder<Trigger, Effect, Message> {
        handle { state in
            
            @Sendable
            func provide() -> Scene<Trigger, Effect> {
                Scene { extras, trigger in
                    let (isLoop, effects) = function(trigger, extras.logger)
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
