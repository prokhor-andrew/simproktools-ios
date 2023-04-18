//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Outline {
    
    
    func switchOnTransition(
        to outline: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>,
        doneOnFinale: Bool = true
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        if doneOnFinale {
            if let transit {
                if let outlineTransit = outline.transit {
                    return Outline.create { trigger in
                        if let transition = outlineTransit(trigger) {
                            return transition
                        } else {
                            if let transition = transit(trigger) {
                                return OutlineTransition(
                                    transition.state.switchOnTransition(to: outline, doneOnFinale: doneOnFinale),
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
            if let outlineTransit = outline.transit {
                return Outline.create { trigger in
                    if let transition = outlineTransit(trigger) {
                        return transition
                    } else {
                        if let transit {
                            if let transition = transit(trigger) {
                                return OutlineTransition(
                                    transition.state.switchOnTransition(to: outline, doneOnFinale: doneOnFinale),
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
