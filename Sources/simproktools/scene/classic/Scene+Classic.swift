//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    static func classic(_ function: @escaping Mapper<Trigger, [Effect]>) -> Scene<Trigger, Effect> {
        classic(Void()) { state, event in
            (state, effects: function(event))
        }
    }

    static func classic<State>(
            _ initial: State,
            function: @escaping BiMapper<State, Trigger, (State?, effects: [Effect])>
    ) -> Scene<Trigger, Effect> {
        Scene.create { trigger in
            let (newState, effects) = function(initial, trigger)
            if let newState {
                return SceneTransition(
                        classic(newState, function: function),
                        effects: effects
                )
            } else {
                return SceneTransition(
                        .finale(),
                        effects: effects
                )
            }
        }
    }
}