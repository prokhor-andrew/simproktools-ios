////
//// Created by Andriy Prokhorenko on 19.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//public extension Outline {
//
//    func mapTrigger<RIntTrigger, RExtTrigger>(
//        function: @escaping (OutlineExtras, FeatureEvent<RIntTrigger, RExtTrigger>) -> FeatureEvent<IntTrigger, ExtTrigger>?
//    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> {
//        mapTrigger(with: Void()) {
//            ($1, function($0, $2))
//        }
//    }
//
//    func mapTrigger<State, RIntTrigger, RExtTrigger>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (OutlineExtras, State, FeatureEvent<RIntTrigger, RExtTrigger>) -> (newState: State, trigger: FeatureEvent<IntTrigger, ExtTrigger>?)
//    ) -> Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> {
//        Outline<RIntTrigger, IntEffect, RExtTrigger, ExtEffect> { extras, trigger in
//            let (newState, mapped) = function(extras, state(), trigger)
//
//            if let mapped {
//                let transition = transit(mapped, extras.machineId, extras.logger)
//                return OutlineTransition(
//                    transition.state.mapTrigger(with: newState, function: function),
//                    effects: transition.effects
//                )
//            } else {
//                return OutlineTransition(
//                    mapTrigger(with: newState, function: function)
//                )
//            }
//        }
//    }
//
//    func mapIntTrigger<RIntTrigger>(
//        function: @escaping (OutlineExtras, RIntTrigger) -> IntTrigger?
//    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        mapIntTrigger(with: Void()) { extras, state, trigger in
//            (state, function(extras, trigger))
//        }
//    }
//
//    func mapExtTrigger<RExtTrigger>(
//        function: @escaping (OutlineExtras, RExtTrigger) -> ExtTrigger?
//    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect> {
//        mapExtTrigger(with: Void()) { extras, state, trigger in
//            (state, function(extras, trigger))
//        }
//    }
//
//    func mapIntTrigger<State, RIntTrigger>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (OutlineExtras, State, RIntTrigger) -> (newState: State, trigger: IntTrigger?)
//    ) -> Outline<RIntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        mapTrigger(with: state()) { extras, state, trigger in
//            switch trigger {
//            case .int(let value):
//                let (newState, mapped) = function(extras, state, value)
//                if let mapped {
//                    return (newState, .int(mapped))
//                } else {
//                    return (newState, nil)
//                }
//            case .ext:
//                return (state, nil)
//            }
//        }
//    }
//
//    func mapExtTrigger<State, RExtTrigger>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (OutlineExtras, State, RExtTrigger) -> (newState: State, trigger: ExtTrigger?)
//    ) -> Outline<IntTrigger, IntEffect, RExtTrigger, ExtEffect> {
//        mapTrigger(with: state()) { extras, state, trigger in
//            switch trigger {
//            case .ext(let value):
//                let (newState, mapped) = function(extras, state, value)
//                if let mapped {
//                    return (newState, .ext(mapped))
//                } else {
//                    return (newState, nil)
//                }
//            case .int:
//                return (state, nil)
//            }
//        }
//    }
//
//    func mapEffects<RIntEffect, RExtEffect>(
//        function: @escaping (OutlineExtras, [FeatureEvent<IntEffect, ExtEffect>]) -> [FeatureEvent<RIntEffect, RExtEffect>]
//    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> {
//        mapEffects(with: Void()) {
//            ($1, effects: function($0, $2))
//        }
//    }
//
//    func mapEffects<State, RIntEffect, RExtEffect>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (OutlineExtras, State, [FeatureEvent<IntEffect, ExtEffect>]) -> (newState: State, effects: [FeatureEvent<RIntEffect, RExtEffect>])
//    ) -> Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> {
//        Outline<IntTrigger, RIntEffect, ExtTrigger, RExtEffect> { extras, trigger in
//            let transition = transit(trigger, extras.machineId, extras.logger)
//            let (newState, mapped) = function(extras, state(), transition.effects)
//            return OutlineTransition(
//                transition.state.mapEffects(with: newState, function: function),
//                effects: mapped
//            )
//        }
//    }
//}
