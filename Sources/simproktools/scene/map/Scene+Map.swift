//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    func mapTrigger<RTrigger>(_ function: @escaping (RTrigger, (Loggable) -> Void) -> Trigger?) -> Scene<RTrigger, Effect> {
        mapTrigger(with: Void()) {
            ($0, trigger: function($1, $2))
        }
    }

    func mapTrigger<State, RTrigger>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, RTrigger, (Loggable) -> Void) -> (newState: State, trigger: Trigger?)
    ) -> Scene<RTrigger, Effect> {
        Scene<RTrigger, Effect> { extras, trigger in
            let (newState, mapped) = function(state(), trigger, extras.logger)

            if let mapped {
                let transition = transit(mapped, extras.logger)
                return SceneTransition(
                    transition.state.mapTrigger(with: newState, function: function),
                    effects: transition.effects
                )
            } else {
                return SceneTransition(
                    mapTrigger(with: newState, function: function)
                )
            }
        }
    }

    func mapEffects<REffect>(_ function: @escaping ([Effect], (Loggable) -> Void) -> [REffect]) -> Scene<Trigger, REffect> {
        mapEffects(with: Void()) {
            ($0, effects: function($1, $2))
        }
    }

    func mapEffects<State, REffect>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, [Effect], (Loggable) -> Void) -> (newState: State, effects: [REffect])
    ) -> Scene<Trigger, REffect> {
        Scene<Trigger, REffect> { extras, trigger in
            let transition = transit(trigger, extras.logger)
            let (newState, mapped) = function(state(), transition.effects, extras.logger)
            return SceneTransition(transition.state.mapEffects(with: newState, function: function), effects: mapped)
        }
    }
}
