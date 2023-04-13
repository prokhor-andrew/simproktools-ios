//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate


public extension Outline {

    static func split(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
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

        return Outline.create { trigger in
            for outline in outlines {
                if let transit = outline.transit,
                   let result = transit(trigger) {
                    return result
                }
            }

            return nil
        }
    }

    static func split(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        split(Set(outlines))
    }

    func or(
            _ outlines: Set<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline.split(outlines.union([self]))
    }

    func or(
            _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        or(Set(outlines))
    }
}
