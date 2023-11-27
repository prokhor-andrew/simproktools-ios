//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    static func classic(_ function: @escaping (Trigger, (Message) -> Void) -> [Effect]) -> Scene<Trigger, Effect, Message> {
        classic(Void()) { state, event, logger in
            (state, function(event, logger))
        }
    }

    static func classic<State>(
        _ initial: @autoclosure @escaping () -> State,
        function: @escaping (State, Trigger, (Message) -> Void) -> (newState: State, effects: [Effect])
    ) -> Scene<Trigger, Effect, Message> {
        Scene { trigger, logger in
            let (newState, effects) = function(initial(), trigger, logger)
            return SceneTransition(
                classic(newState, function: function),
                effects: effects
            )
        }
    }
}
