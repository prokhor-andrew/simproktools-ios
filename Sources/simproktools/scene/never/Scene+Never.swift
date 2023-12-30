////
//// Created by Andriy Prokhorenko on 17.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//public extension Scene {
//
//    static func never(doOnTrigger: @escaping (SceneExtras) -> Void = { _ in }) -> Scene<Trigger, Effect> {
//        Scene { extras, trigger in
//            doOnTrigger(extras)
//            return SceneTransition(never(doOnTrigger: doOnTrigger))
//        }
//    }
//}
