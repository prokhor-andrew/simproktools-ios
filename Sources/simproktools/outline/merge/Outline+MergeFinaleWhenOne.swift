//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate


public extension Outline {
    
    // isFinaleChecked added to remove unnecessary loops
    private static func mergeFinaleWhenOne(
            isFinaleChecked: Bool,
            outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        if !isFinaleChecked {
            func isFinale() -> Bool {
                for outline in outlines {
                    if outline.isFinale {
                        return true
                    }
                }

                return false
            }

            if isFinale() {
                return .finale()
            }
        }

        return Outline.create { trigger in
            var isFinale = false

            var effects: [FeatureEvent<IntEffect, ExtEffect>] = []
            
            let mapped = Set(outlines.map { outline in
                if let transit = outline.transit {
                    if let transition = transit(trigger) {
                        effects.append(contentsOf: transition.effects)
                        if transition.state.isFinale {
                            isFinale = true
                        }
                        
                        return transition.state
                    } else {
                        return outline
                    }
                } else {
                    isFinale = true
                    return outline
                }
            })
            
            
            if isFinale {
                return OutlineTransition(.finale(), effects: effects)
            } else {
                return OutlineTransition(mergeFinaleWhenOne(isFinaleChecked: true, outlines: mapped), effects: effects)
            }
        }
    }

    static func mergeFinaleWhenOne(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mergeFinaleWhenOne(isFinaleChecked: false, outlines: outlines)
    }
    
    static func mergeFinaleWhenOne(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mergeFinaleWhenOne(Set(outlines))
    }

    func andFinaleWhenOne(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        .mergeFinaleWhenOne(outlines.union([self]))
    }

    func andFinaleWhenOne(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        andFinaleWhenOne(Set(outlines))
    }
}
