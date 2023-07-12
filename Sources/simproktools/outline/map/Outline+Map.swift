//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate

public extension Outline {

    func mapTrigger<RIntTrigger, RExtTrigger>(
            function: @escaping (FeatureEvent<RIntTrigger, RExtTrigger>) -> FeatureEvent<IntTrigger, ExtTrigger>?
    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        mapTrigger(with: Void()) {
            ($0, function($1))
        }
    }

    func mapTrigger<State, RIntTrigger, RExtTrigger>(
            with state: State,
            function: @escaping (State, FeatureEvent<RIntTrigger, RExtTrigger>) -> (newState: State, trigger: FeatureEvent<IntTrigger, ExtTrigger>?)
    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        if let transit {
            return Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect>.create { trigger in
                let (newState, mapped) = function(state, trigger)

                if let mapped, let transition = transit(mapped) {
                    return OutlineTransition(
                            transition.state.mapTrigger(with: newState, function: function),
                            effects: transition.effects
                    )
                } else {
                    return OutlineTransition(
                        mapTrigger(with: newState, function: function)
                    )
                }
            }

        } else {
            return Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect>.finale()
        }
    }

    func mapIntTrigger<RIntTrigger>(
            function: @escaping (RIntTrigger) -> IntTrigger?
    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mapTrigger { trigger in
            switch trigger {
            case .int(let value):
                if let result = function(value) {
                    return .int(result)
                } else {
                    return nil
                }
            case .ext:
                return nil
            }
        }
    }

    func mapExtTrigger<RExtTrigger>(
            function: @escaping (RExtTrigger) -> ExtTrigger?
    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        mapTrigger { trigger in
            switch trigger {
            case .ext(let value):
                if let result = function(value) {
                    return .ext(result)
                } else {
                    return nil
                }
            case .int:
                return nil
            }
        }
    }

    func mapIntTrigger<State, RIntTrigger>(
            with state: State,
            function: @escaping (State, RIntTrigger) -> (newState: State, trigger: IntTrigger?)
    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mapTrigger(with: state) { state, event in
            switch event {
            case .int(let value):
                let (newState, mapped) = function(state, value)
                if let mapped {
                    return (newState, .int(mapped))
                } else {
                    return (newState, nil)
                }
            case .ext:
                return (state, nil)
            }
        }
    }

    func mapExtTrigger<State, RExtTrigger>(
            with state: State,
            function: @escaping (State, RExtTrigger) -> (newState: State, trigger: ExtTrigger?)
    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        mapTrigger(with: state) { state, event in
            switch event {
            case .ext(let value):
                let (newState, mapped) = function(state, value)
                if let mapped {
                    return (newState, .ext(mapped))
                } else {
                    return (newState, nil)
                }
            case .int:
                return (state, nil)
            }
        }
    }

    func mapEffects<RIntEffect, RExtEffect>(
            function: @escaping ([FeatureEvent<IntEffect, ExtEffect>]) -> [FeatureEvent<RIntEffect, RExtEffect>]
    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> {
        mapEffects(with: Void()) {
            ($0, effects: function($1))
        }
    }

    func mapEffects<State, RIntEffect, RExtEffect>(
            with state: State,
            function: @escaping (State, [FeatureEvent<IntEffect, ExtEffect>]) -> (newState: State, effects: [FeatureEvent<RIntEffect, RExtEffect>])
    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> {
        if let transit {
            return Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect>.create { trigger in
                if let transition = transit(trigger) {
                    let (newState, mapped) = function(state, transition.effects)
                    return OutlineTransition(
                        transition.state.mapEffects(with: newState, function: function),
                        effects: mapped
                    )
                } else {
                    return nil
                }
            }
        } else {
            return Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect>.finale()
        }
    }
}
