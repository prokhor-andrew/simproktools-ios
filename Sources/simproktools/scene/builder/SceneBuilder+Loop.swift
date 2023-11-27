//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate


public extension SceneBuilder {
    
    func loop(
        _ function: @escaping (Trigger, (Message) -> Void) -> (Bool, [Effect])
    ) -> SceneBuilder<Trigger, Effect, Message> {
        handle { state in
            
            @Sendable
            func provide() -> Scene<Trigger, Effect, Message> {
                Scene { event, logger in
                    let (isLoop, effects) = function(event, logger)
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
