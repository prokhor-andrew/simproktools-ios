//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    func mapTrigger<RTrigger>(_ function: @escaping (RTrigger, (String) -> Void) -> Trigger?) -> Scene<RTrigger, Effect> {
        mapTrigger(with: Void()) {
            ($0, trigger: function($1, $2))
        }
    }

    func mapTrigger<State, RTrigger>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, RTrigger, (String) -> Void) -> (newState: State, trigger: Trigger?)
    ) -> Scene<RTrigger, Effect> {
        Scene<RTrigger, Effect> { trigger, logger in
            let (newState, mapped) = function(state(), trigger, logger)

            if let mapped {
                let transition = transit(mapped, logger)
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

    func mapEffects<REffect>(_ function: @escaping ([Effect], (String) -> Void) -> [REffect]) -> Scene<Trigger, REffect> {
        mapEffects(with: Void()) {
            ($0, effects: function($1, $2))
        }
    }

    func mapEffects<State, REffect>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, [Effect], (String) -> Void) -> (newState: State, effects: [REffect])
    ) -> Scene<Trigger, REffect> {
        Scene<Trigger, REffect> { trigger, logger in
            let transition = transit(trigger, logger)
            let (newState, mapped) = function(state(), transition.effects, logger)
            return SceneTransition(transition.state.mapEffects(with: newState, function: function), effects: mapped)
        }
    }
}
