////
//// Created by Andriy Prokhorenko on 17.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//public extension Scene {
//
//    func mapTrigger<RTrigger>(_ function: @escaping (SceneExtras, RTrigger) -> Trigger?) -> Scene<RTrigger, Effect> {
//        mapTrigger(with: Void()) {
//            ($1, trigger: function($0, $2))
//        }
//    }
//
//    func mapTrigger<State, RTrigger>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (SceneExtras, State, RTrigger) -> (newState: State, trigger: Trigger?)
//    ) -> Scene<RTrigger, Effect> {
//        Scene<RTrigger, Effect> { extras, trigger in
//            let (newState, mapped) = function(extras, state(), trigger)
//
//            if let mapped {
//                let transition = transit(mapped, extras.machineId, extras.logger)
//                return SceneTransition(
//                    transition.state.mapTrigger(with: newState, function: function),
//                    effects: transition.effects
//                )
//            } else {
//                return SceneTransition(
//                    mapTrigger(with: newState, function: function)
//                )
//            }
//        }
//    }
//
//    func mapEffects<REffect>(_ function: @escaping (SceneExtras, [Effect]) -> [REffect]) -> Scene<Trigger, REffect> {
//        mapEffects(with: Void()) {
//            ($1, effects: function($0, $2))
//        }
//    }
//
//    func mapEffects<State, REffect>(
//        with state: @autoclosure @escaping () -> State,
//        function: @escaping (SceneExtras, State, [Effect]) -> (newState: State, effects: [REffect])
//    ) -> Scene<Trigger, REffect> {
//        Scene<Trigger, REffect> { extras, trigger in
//            let transition = transit(trigger, extras.machineId, extras.logger)
//            let (newState, mapped) = function(extras, state(), transition.effects)
//            return SceneTransition(transition.state.mapEffects(with: newState, function: function), effects: mapped)
//        }
//    }
//}
