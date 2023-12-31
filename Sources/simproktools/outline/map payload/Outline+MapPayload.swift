//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    func mapPayload<R>(function: @escaping (Payload) -> R) -> Outline<R, IntTrigger, IntEffect, ExtTrigger, ExtEffect, Loggable> {
        Outline<R, IntTrigger, IntEffect, ExtTrigger, ExtEffect, Loggable>(payload: function(payload)) { extras, trigger in
            let transition = transit(trigger, extras.machineId, extras.logger)
            return OutlineTransition(
                transition.state.mapPayload(function: function),
                effects: transition.effects
            )
        }
    }
}
