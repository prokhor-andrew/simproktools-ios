//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    func mapTrigger<RIntTrigger, RExtTrigger>(
        function: @escaping (FeatureEvent<RIntTrigger, RExtTrigger>, (String) -> Void) -> FeatureEvent<IntTrigger, ExtTrigger>?
    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        mapTrigger(with: Void()) {
            ($0, function($1, $2))
        }
    }

    func mapTrigger<State, RIntTrigger, RExtTrigger>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, FeatureEvent<RIntTrigger, RExtTrigger>, (String) -> Void) -> (newState: State, trigger: FeatureEvent<IntTrigger, ExtTrigger>?)
    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> { trigger, logger in
            let (newState, mapped) = function(state(), trigger, logger)

            if let mapped {
                let transition = transit(mapped, logger)
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
    }

    func mapIntTrigger<RIntTrigger>(
        function: @escaping (RIntTrigger, (String) -> Void) -> IntTrigger?
    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mapIntTrigger(with: Void()) { state, trigger, logger in
            (state, function(trigger, logger))
        }
    }

    func mapExtTrigger<RExtTrigger>(
        function: @escaping (RExtTrigger, (String) -> Void) -> ExtTrigger?
    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        mapExtTrigger(with: Void()) { state, trigger, logger in
            (state, function(trigger, logger))
        }
    }

    func mapIntTrigger<State, RIntTrigger>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, RIntTrigger, (String) -> Void) -> (newState: State, trigger: IntTrigger?)
    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mapTrigger(with: state()) { state, event, logger in
            switch event {
            case .int(let value):
                let (newState, mapped) = function(state, value, logger)
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
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, RExtTrigger, (String) -> Void) -> (newState: State, trigger: ExtTrigger?)
    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect> {
        mapTrigger(with: state()) { state, event, logger in
            switch event {
            case .ext(let value):
                let (newState, mapped) = function(state, value, logger)
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
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, [FeatureEvent<IntEffect, ExtEffect>]) -> (newState: State, effects: [FeatureEvent<RIntEffect, RExtEffect>])
    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> {
        Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> { trigger, logger in
            let transition = transit(trigger, logger)
            let (newState, mapped) = function(state(), transition.effects)
            return OutlineTransition(
                transition.state.mapEffects(with: newState, function: function),
                effects: mapped
            )
        }
    }
}
