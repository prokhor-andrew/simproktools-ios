//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate

public extension Outline {

    func flatMap(
            _ initial: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>? = nil,
            function: @escaping BiMapper<Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>?, [FeatureEvent<IntEffect, ExtEffect>], Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>?>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        guard let transit else {
            return initial ?? .finale()
        }

        let main = Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>.create { trigger in
            if let transition = transit(trigger) {
                let effects = transition.effects
                return OutlineTransition(
                        transition.state.flatMap(function(initial, effects), function: function),
                        effects: effects
                )
            } else {
                return OutlineTransition(flatMap(initial, function: function))
            }
        }

        if let initial {
            return main.and(initial)
        } else {
            return main
        }
    }
}
