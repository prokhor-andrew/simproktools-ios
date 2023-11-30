//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    static func classic(_ function: @escaping (SceneExtras, Trigger) -> [Effect]) -> Scene<Trigger, Effect> {
        classic(Void()) { extras, state, event in
            (state, function(extras, event))
        }
    }

    static func classic<State>(
        _ initial: @autoclosure @escaping () -> State,
        function: @escaping (SceneExtras, State, Trigger) -> (newState: State, effects: [Effect])
    ) -> Scene<Trigger, Effect> {
        Scene { extras, trigger in
            let (newState, effects) = function(extras, initial(), trigger)
            return SceneTransition(
                classic(newState, function: function),
                effects: effects
            )
        }
    }
}
