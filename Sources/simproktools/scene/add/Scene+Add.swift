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
//public extension Scene {
//    
//    func add<R>(_ parent: @autoclosure @escaping () -> Scene<Effect, R>) -> Scene<Trigger, R> {
//        
//        @Sendable
//        func _child(
//            _ trigger: Trigger,
//            child: Scene<Trigger, Effect>,
//            parent: Scene<Effect, R>,
//            machineId: String,
//            logger: MachineLogger
//        ) -> (
//            child: Scene<Trigger, Effect>,
//            parent: Scene<Effect, R>,
//            effects: [R]
//        ) {
//            let transition = child.transit(trigger, machineId, logger)
//            let new = transition.state
//            let effects = transition.effects
//            
//            let result = effects.reduce((
//                child: new,
//                parent: parent,
//                effects: [R]()
//            )) { state, effect in
//                let child = state.child
//                let parent = state.parent
//                let effects = state.effects
//                
//                let newState = _parent(effect, child: child, parent: parent, machineId: machineId, logger: logger)
//                return (newState.child, newState.parent, effects + newState.effects)
//            }
//            
//            
//            return result
//        }
//        
//        
//        @Sendable
//        func _parent(
//            _ trigger: Effect,
//            child: Scene<Trigger, Effect>,
//            parent: Scene<Effect, R>,
//            machineId: String,
//            logger: MachineLogger
//        ) -> (
//            child: Scene<Trigger, Effect>,
//            parent: Scene<Effect, R>,
//            effects: [R]
//        ) {
//            let transition = parent.transit(trigger, machineId, logger)
//            let new = transition.state
//            let effects = transition.effects
//            
//            return (child, new, effects)
//        }
//        
//        
//        return Scene<Trigger, R> { extras, trigger in
//            let result = _child(trigger, child: self, parent: parent(), machineId: extras.machineId, logger: extras.logger)
//            return SceneTransition(
//                result.child.add(result.parent),
//                effects: result.effects
//            )
//        }
//    }
//    
//    
//    
//    func add<R>(_ parent: @autoclosure @escaping () -> Scene<R, Trigger>) -> Scene<R, Effect> {
//        @Sendable
//        func _child(
//            _ trigger: Trigger,
//            child: Scene<Trigger, Effect>,
//            parent: Scene<R, Trigger>,
//            machineId: String,
//            logger: MachineLogger
//        ) -> (
//            child: Scene<Trigger, Effect>,
//            parent: Scene<R, Trigger>,
//            effects: [Effect]
//        ) {
//            let transition = child.transit(trigger, machineId, logger)
//            let new = transition.state
//            let effects = transition.effects
//            
//            return (new, parent, effects)
//        }
//        
//        
//        @Sendable
//        func _parent(
//            _ trigger: R,
//            child: Scene<Trigger, Effect>,
//            parent: Scene<R, Trigger>,
//            machineId: String,
//            logger: MachineLogger
//        ) -> (
//            child: Scene<Trigger, Effect>,
//            parent: Scene<R, Trigger>,
//            effects: [Effect]
//        ) {
//            let transition = parent.transit(trigger, machineId, logger)
//            let new = transition.state
//            let effects = transition.effects
//            
//            
//            let result = effects.reduce((
//                child: child,
//                parent: new,
//                effects: [Effect]()
//            )) { state, effect in
//                let child: Scene<Trigger, Effect> = state.child
//                let parent = state.parent
//                let effects = state.effects
//                
//                let newState = _child(effect, child: child, parent: parent, machineId: machineId, logger: logger)
//                return (newState.child, newState.parent, effects + newState.effects)
//            }
//            
//            
//            return result
//        }
//        
//        return Scene<R, Effect> { extras, trigger in
//            let result = _parent(trigger, child: self, parent: parent(), machineId: extras.machineId, logger: extras.logger)
//            return SceneTransition(
//                result.child.add(result.parent),
//                effects: result.effects
//            )
//        }
//    }
//}
//
