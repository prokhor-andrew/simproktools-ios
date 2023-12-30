////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 04.12.2023.
////
//
//import simprokmachine
//import simprokstate
//
//public extension Outline {
//    
//    func add<Input, Output>(
//        _ parent: @autoclosure @escaping () -> Outline<ExtEffect, ExtTrigger, Input, Output>
//    ) -> Outline<IntTrigger, IntEffect, Input, Output> {
//        
//        @Sendable
//        func _child(
//            _ trigger: FeatureEvent<IntTrigger, ExtTrigger>,
//            child: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>,
//            parent: Outline<ExtEffect, ExtTrigger, Input, Output>,
//            machineId: String,
//            logger: MachineLogger
//        ) -> (
//            child: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>,
//            parent: Outline<ExtEffect, ExtTrigger, Input, Output>,
//            effects: [FeatureEvent<IntEffect, Output>]
//        ) {
//            let transition = child.transit(trigger, machineId, logger)
//            let new = transition.state
//            let effects = transition.effects
//            
//            return effects.reduce((
//                child: new,
//                parent: parent,
//                effects: [FeatureEvent<IntEffect, Output>]()
//            )) { state, effect in
//                let child = state.child
//                let parent = state.parent
//                let effects = state.effects
//                
//                switch effect {
//                case .int(let val):
//                    return (child: child, parent: parent, effects + [.int(val)])
//                case .ext(let val):
//                    let newState = _parent(.int(val), child: child, parent: parent, machineId: machineId, logger: logger)
//                    return (newState.child, newState.parent, effects + newState.effects)
//                }
//            }
//        }
//        
//        
//        @Sendable
//        func _parent(
//            _ trigger: FeatureEvent<ExtEffect, Input>,
//            child: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>,
//            parent: Outline<ExtEffect, ExtTrigger, Input, Output>,
//            machineId: String,
//            logger: MachineLogger
//        ) -> (
//            child: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>,
//            parent: Outline<ExtEffect, ExtTrigger, Input, Output>,
//            effects: [FeatureEvent<IntEffect, Output>]
//        ) {
//            let transition = parent.transit(trigger, machineId, logger)
//            let new = transition.state
//            let effects = transition.effects
//            
//            return effects.reduce((
//                child: child,
//                parent: new,
//                effects: [FeatureEvent<IntEffect, Output>]()
//            )) { state, effect in
//                let child = state.child
//                let parent = state.parent
//                let effects = state.effects
//                
//                switch effect {
//                case .ext(let val):
//                    return (child: child, parent: parent, effects + [.ext(val)])
//                case .int(let val):
//                    let newState = _child(.ext(val), child: child, parent: parent, machineId: machineId, logger: logger)
//                    return (newState.child, newState.parent, effects + newState.effects)
//                }
//            }
//        }
//        
//        
//        return Outline<IntTrigger, IntEffect, Input, Output> { extras, trigger in
//            let parent = parent()
//            switch trigger {
//            case .int(let val):
//                let result = _child(.int(val), child: self, parent: parent, machineId: extras.machineId, logger: extras.logger)
//                let child = result.child
//                let parent = result.parent
//                let effects = result.effects
//                return OutlineTransition(
//                    child.add(parent),
//                    effects: effects
//                )
//            case .ext(let val):
//                let result = _parent(.ext(val), child: self, parent: parent, machineId: extras.machineId, logger: extras.logger)
//                let child = result.child
//                let parent = result.parent
//                let effects = result.effects
//                
//                return OutlineTransition(
//                    child.add(parent),
//                    effects: effects
//                )
//            }
//        }
//    }
//}
