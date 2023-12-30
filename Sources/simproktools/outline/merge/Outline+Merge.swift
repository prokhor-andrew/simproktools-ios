////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 24.11.2023.
////
//
//import simprokstate
//
//
//public extension Outline {
//
//    
//    static func merge(
//        _ outlines: @autoclosure @escaping () -> [Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>]
//    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        Outline { extras, trigger in
//            var effects: [FeatureEvent<IntEffect, ExtEffect>] = []
//            
//            let mapped = outlines().map { outline in
//                let transition = outline.transit(trigger, extras.machineId, extras.logger)
//                effects.append(contentsOf: transition.effects)
//                return transition.state
//            }
//            
//            return OutlineTransition(merge(mapped), effects: effects)
//        }
//    }
//    
//    static func merge(
//        _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...
//    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
//        merge(outlines)
//    }
//}
