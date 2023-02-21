//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    // isFinaleChecked added to remove unnecessary loops
    private static func merge(
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
                    isFinale = false
                    let transition = transit(trigger)
                    effects.append(contentsOf: transition.effects)
                    return transition.state
                } else {
                    return outline
                }
            })

            if isFinale {
                return OutlineTransition(.finale())
            } else {
                return OutlineTransition(merge(isFinaleChecked: true, outlines: mapped), effects: effects)
            }
        }
    }

    static func merge(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        merge(isFinaleChecked: false, outlines: outlines)
    }

    static func merge(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        merge(Set(outlines))
    }

    func and(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        .merge(outlines.union([self]))
    }

    func and(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        and(Set(outlines))
    }
}