//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    static func classic(_ function: @escaping (Trigger) -> [Effect]) -> Scene<Trigger, Effect> {
        classic(Void()) { state, event in
            (state, function(event))
        }
    }

    static func classic<State>(
        _ initial: State,
        function: @escaping (State, Trigger) -> (newState: State, effects: [Effect])
    ) -> Scene<Trigger, Effect> {
        Scene { trigger in
            let (newState, effects) = function(initial, trigger)
            return SceneTransition(
                classic(newState, function: function),
                effects: effects
            )
        }
    }
}
