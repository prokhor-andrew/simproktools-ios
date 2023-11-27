//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    func mapTrigger<RIntTrigger, RExtTrigger>(
        function: @escaping (FeatureEvent<RIntTrigger, RExtTrigger>, (Message) -> Void) -> FeatureEvent<IntTrigger, ExtTrigger>?
    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect, Message> {
        mapTrigger(with: Void()) {
            ($0, function($1, $2))
        }
    }

    func mapTrigger<State, RIntTrigger, RExtTrigger>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, FeatureEvent<RIntTrigger, RExtTrigger>, (Message) -> Void) -> (newState: State, trigger: FeatureEvent<IntTrigger, ExtTrigger>?)
    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect, Message> {
        Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect, Message> { trigger, logger in
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
        function: @escaping (RIntTrigger, (Message) -> Void) -> IntTrigger?
    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        mapIntTrigger(with: Void()) { state, trigger, logger in
            (state, function(trigger, logger))
        }
    }

    func mapExtTrigger<RExtTrigger>(
        function: @escaping (RExtTrigger, (Message) -> Void) -> ExtTrigger?
    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect, Message> {
        mapExtTrigger(with: Void()) { state, trigger, logger in
            (state, function(trigger, logger))
        }
    }

    func mapIntTrigger<State, RIntTrigger>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, RIntTrigger, (Message) -> Void) -> (newState: State, trigger: IntTrigger?)
    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
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
        function: @escaping (State, RExtTrigger, (Message) -> Void) -> (newState: State, trigger: ExtTrigger?)
    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect, Message> {
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
    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect, Message> {
        mapEffects(with: Void()) {
            ($0, effects: function($1))
        }
    }

    func mapEffects<State, RIntEffect, RExtEffect>(
        with state: @autoclosure @escaping () -> State,
        function: @escaping (State, [FeatureEvent<IntEffect, ExtEffect>]) -> (newState: State, effects: [FeatureEvent<RIntEffect, RExtEffect>])
    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect, Message> {
        Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect, Message> { trigger, logger in
            let transition = transit(trigger, logger)
            let (newState, mapped) = function(state(), transition.effects)
            return OutlineTransition(
                transition.state.mapEffects(with: newState, function: function),
                effects: mapped
            )
        }
    }
}
