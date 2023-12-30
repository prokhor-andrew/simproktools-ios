////
//// Created by Andriy Prokhorenko on 19.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//public extension Outline {
//
//    static func classic<State>(
//        _ initial: @autoclosure @escaping () -> State,
//        function: @escaping (OutlineExtras, State, FeatureEvent<IntTrigger, ExtTrigger>) -> (newState: State, effects: [FeatureEvent<IntEffect, ExtEffect>])
//    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        Outline { extras, trigger in
//            let (newState, effects) = function(extras, initial(), trigger)
//            return OutlineTransition(
//                classic(newState, function: function),
//                effects: effects
//            )
//        }
//    }
//    
//    static func classic(
//        function: @escaping (OutlineExtras, FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]
//    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        classic(Void()) { extras, state, trigger in
//            (state, function(extras, trigger))
//        }
//    }
//}
