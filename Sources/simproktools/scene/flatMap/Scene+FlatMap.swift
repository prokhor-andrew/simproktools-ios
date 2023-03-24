//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    func flatMap(
            _ initial: Scene<Trigger, Effect>? = nil,
            function: @escaping BiMapper<Scene<Trigger, Effect>?, [Effect], Scene<Trigger, Effect>?>
    ) -> Scene<Trigger, Effect> {
        guard let transit else {
            return initial ?? .finale()
        }

        let main = Scene<Trigger, Effect>.create { trigger in
            if let transition = transit(trigger) {
                let effects = transition.effects
                return SceneTransition(
                        transition.state.flatMap(function(initial, effects), function: function),
                        effects: effects
                )
            } else {
                return SceneTransition(flatMap(initial, function: function))
            }
        }

        if let initial {
            return main.and(initial)
        } else {
            return main
        }
    }
}
