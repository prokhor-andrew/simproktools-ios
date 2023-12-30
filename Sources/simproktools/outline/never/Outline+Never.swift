////
//// Created by Andriy Prokhorenko on 19.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//
//public extension Outline {
//
//    static func never(doOnTrigger: @escaping (OutlineExtras) -> Void = { _ in }) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        Outline { extras, trigger in
//            doOnTrigger(extras)
//            return OutlineTransition(never(doOnTrigger: doOnTrigger))
//        }
//    }
//}
