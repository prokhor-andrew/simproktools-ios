////
////  File.swift
////
////
////  Created by Andriy Prokhorenko on 27.10.2023.
////
//
//import simprokstate
//
//
//public extension Scene {
//
//    
//    static func merge(
//        _ scenes: @autoclosure @escaping () -> [Scene<Trigger, Effect>]
//    ) -> Scene<Trigger, Effect> {
//        return Scene { extras, trigger in
//            var effects: [Effect] = []
//            
//            let mapped = scenes().map { scene in
//                let transition = scene.transit(trigger, extras.machineId, extras.logger)
//                effects.append(contentsOf: transition.effects)
//                return transition.state
//            }
//            
//            return SceneTransition(merge(mapped), effects: effects)
//        }
//    }
//    
//    static func merge(
//        _ scenes: Scene<Trigger, Effect>...
//    ) -> Scene<Trigger, Effect> {
//        merge(scenes)
//    }
//}
