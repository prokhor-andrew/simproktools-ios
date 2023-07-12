//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    func mapTrigger<RTrigger>(_ function: @escaping (RTrigger) -> Trigger?) -> Scene<RTrigger, Effect> {
        mapTrigger(with: Void()) {
            ($0, trigger: function($1))
        }
    }

    func mapTrigger<State, RTrigger>(with state: State, function: @escaping (State, RTrigger) -> (newState: State, trigger: Trigger?)) -> Scene<RTrigger, Effect> {
        if let transit {
            return Scene<RTrigger, Effect>.create { trigger in
                let (newState, mapped) = function(state, trigger)

                if let mapped, let transition = transit(mapped) {
                    return SceneTransition(
                            transition.state.mapTrigger(with: newState, function: function),
                            effects: transition.effects
                    )
                } else {
                    return nil
                }
            }
        } else {
            return Scene<RTrigger, Effect>.finale()
        }
    }

    func mapEffects<REffect>(_ function: @escaping ([Effect]) -> [REffect]) -> Scene<Trigger, REffect> {
        mapEffects(with: Void()) {
            ($0, effects: function($1))
        }
    }

    func mapEffects<State, REffect>(with state: State, function: @escaping (State, [Effect]) -> (newState: State, effects: [REffect])) -> Scene<Trigger, REffect> {
        if let transit {
            return Scene<Trigger, REffect>.create { trigger in
                if let transition = transit(trigger) {
                    let (newState, mapped) = function(state, transition.effects)
                    return SceneTransition(transition.state.mapEffects(with: newState, function: function), effects: mapped)
                } else {
                    return nil
                }
            }
        } else {
            return Scene<Trigger, REffect>.finale()
        }
    }
}
