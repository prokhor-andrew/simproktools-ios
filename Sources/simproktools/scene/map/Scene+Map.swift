//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    func mapTrigger<RTrigger>(_ function: @escaping (RTrigger) -> Trigger?) -> Scene<RTrigger, Effect> {
        mapTrigger(with: Void()) {
            ($0, trigger: function($1))
        }
    }

    func mapTrigger<State, RTrigger>(with state: State, function: @escaping (State, RTrigger) -> (newState: State, trigger: Trigger?)) -> Scene<RTrigger, Effect> {
        Scene<RTrigger, Effect> { trigger in
            let (newState, mapped) = function(state, trigger)

            if let mapped {
                let transition = transit(mapped)
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

    func mapEffects<REffect>(_ function: @escaping ([Effect]) -> [REffect]) -> Scene<Trigger, REffect> {
        mapEffects(with: Void()) {
            ($0, effects: function($1))
        }
    }

    func mapEffects<State, REffect>(with state: State, function: @escaping (State, [Effect]) -> (newState: State, effects: [REffect])) -> Scene<Trigger, REffect> {
        Scene<Trigger, REffect> { trigger in
            let transition = transit(trigger)
            let (newState, mapped) = function(state, transition.effects)
            return SceneTransition(transition.state.mapEffects(with: newState, function: function), effects: mapped)
        }
    }
}
