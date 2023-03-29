//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate



public extension Outline {
    
    
    func switchOnFinale(to outline: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        guard let transit else {
            return .finale()
        }
      
        return Outline.create { trigger in
            if let transition = transit(trigger) {
                if transition.state.isFinale {
                    return OutlineTransition(
                        outline,
                        effects: transition.effects
                    )
                } else {
                    return OutlineTransition(
                        transition.state.switchOnFinale(to: outline),
                        effects: transition.effects
                    )
                }
            } else {
                return nil
            }
        }
    }
}
