//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    func mapTrigger<RTrigger>(_ function: @escaping Mapper<RTrigger, Trigger?>) -> Scene<RTrigger, Effect> {
        mapTrigger(with: Void()) {
            ($0, trigger: function($1))
        }
    }

    func mapTrigger<State, RTrigger>(with state: State, function: @escaping BiMapper<State, RTrigger, (State, trigger: Trigger?)>) -> Scene<RTrigger, Effect> {
        if let transit {
            let scene: Scene<RTrigger, Effect> = Scene<RTrigger, Effect>.create { trigger in
                let (newState, mapped) = function(state, trigger)

                if let mapped {
                    let transition = transit(mapped)
                    return SceneTransition(
                            transition.state.mapTrigger(with: newState, function: function),
                            effects: transition.effects
                    )
                } else {
                    return SceneTransition(scene)
                }
            }

            return scene
        } else {
            return Scene<RTrigger, Effect>.finale()
        }
    }

    func mapEffects<REffect>(_ function: @escaping Mapper<[Effect], [REffect]>) -> Scene<Trigger, REffect> {
        mapEffects(with: Void()) {
            ($0, effects: function($1))
        }
    }

    func mapEffects<State, REffect>(with state: State, function: @escaping BiMapper<State, [Effect], (State, effects: [REffect])>) -> Scene<Trigger, REffect> {
        if let transit {
            let scene: Scene<Trigger, REffect> = Scene<Trigger, REffect>.create { trigger in
                let transition = transit(trigger)
                let (newState, mapped) = function(state, transition.effects)
                return SceneTransition(transition.state.mapEffects(with: newState, function: function), effects: mapped)
            }

            return scene
        } else {
            return Scene<Trigger, REffect>.finale()
        }
    }

    func mapEffect<REffect>(_ function: @escaping Mapper<Effect, [REffect]>) -> Scene<Trigger, REffect> {
        if let transit {
            let scene: Scene<Trigger, REffect> = Scene<Trigger, REffect>.create { trigger in
                let transition = transit(trigger)
                let mapped = transition.effects.flatMap {
                    function($0)
                }
                return SceneTransition(transition.state.mapEffect(function), effects: mapped)
            }

            return scene
        } else {
            return Scene<Trigger, REffect>.finale()
        }
    }
}