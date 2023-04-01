//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    // isFinaleChecked added to remove unnecessary loops
    private static func mergeFinaleWhenAll(
            isFinaleChecked: Bool,
            outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        if !isFinaleChecked {
            func isFinale() -> Bool {
                for outline in outlines {
                    if !outline.isFinale {
                        return false
                    }
                }

                return true
            }

            if isFinale() {
                return .finale()
            }
        }

        return Outline.create { trigger in
            var isFinale = true

            var effects: [FeatureEvent<IntEffect, ExtEffect>] = []

            let mapped = Set(outlines.map { outline in
                if let transit = outline.transit {
                    if let transition = transit(trigger) {
                        effects.append(contentsOf: transition.effects)
                        if !transition.state.isFinale {
                            isFinale = false
                        }
                        
                        return transition.state
                    } else {
                        isFinale = false
                        return outline
                    }
                } else {
                    return outline
                }
            })
            

            if isFinale {
                return OutlineTransition(.finale(), effects: effects)
            } else {
                return OutlineTransition(mergeFinaleWhenAll(isFinaleChecked: true, outlines: mapped), effects: effects)
            }
        }
    }

    static func mergeFinaleWhenAll(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mergeFinaleWhenAll(isFinaleChecked: false, outlines: outlines)
    }

    static func mergeFinaleWhenAll(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mergeFinaleWhenAll(Set(outlines))
    }

    func andFinaleWhenAll(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        .mergeFinaleWhenAll(outlines.union([self]))
    }

    func andFinaleWhenAll(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        andFinaleWhenAll(Set(outlines))
    }
}
