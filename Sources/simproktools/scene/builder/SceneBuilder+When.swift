//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate
import CasePaths

public extension SceneBuilder {
    
    func when(
        _ function: @escaping (Trigger) -> [Effect]?
    ) -> SceneBuilder<Trigger, Effect, Message> {
        handle { state in
            
            @Sendable
            func currentState() -> Scene<Trigger, Effect> {
                Scene { event, logger in
                    if let effects = function(event) {
                        return SceneTransition(
                            state,
                            effects: effects
                        )
                    } else {
                        return SceneTransition(currentState())
                    }
                }
            }
            
            return currentState()
        }
    }
    
    func when(
        _ operation: @escaping (Trigger, Trigger) -> Bool,
        _ value: Trigger,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when {
            operation($0, value) ? effects : nil
        }
    }
    
    func when(
        _ operation: @escaping (Trigger, Trigger) -> Bool,
        _ value: Trigger,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(operation, value, send: effects)
    }
}


public extension SceneBuilder where Trigger: Equatable {
    
    func when(
        is trigger: Trigger,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(==, trigger, send: effects)
    }

    func when(
        is trigger: Trigger,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(is: trigger, send: effects)
    }

    func when(
        not trigger: Trigger,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(!=, trigger, send: effects)
    }

    func when(
        not trigger: Trigger,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(not: trigger, send: effects)
    }
}


public extension SceneBuilder {
    
    func when<T>(
        _ keyPath: KeyPath<Trigger, T>,
        function: @escaping (T) -> [Effect]?
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when {
            function($0[keyPath: keyPath])
        }
    }
    
    func when<T>(
        _ keyPath: KeyPath<Trigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(keyPath) {
            operation($0, value) ? effects : nil
        }
    }
    
    func when<T>(
        _ keyPath: KeyPath<Trigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(keyPath, operation, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        is value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        is value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        not value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(keyPath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        not value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(keyPath, !=, value, send: effects)
    }
}



public extension SceneBuilder where Trigger: CasePathable {
    
    func when<T>(
        _ casePath: CaseKeyPath<Trigger, T>,
        function: @escaping (T) -> [Effect]?
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when {
            if let val = $0[case: casePath] {
                function(val)
            } else {
                nil
            }
        }
    }
    
    func when<T>(
        _ casePath: CaseKeyPath<Trigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(casePath) {
            operation($0, value) ? effects : nil
        }
    }
    
    func when<T>(
        _ casePath: CaseKeyPath<Trigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(casePath, operation, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ casePath: CaseKeyPath<Trigger, T>,
        is value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(casePath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ casePath: CaseKeyPath<Trigger, T>,
        is value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(casePath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ casePath: CaseKeyPath<Trigger, T>,
        not value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(casePath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ casePath: CaseKeyPath<Trigger, T>,
        not value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect, Message> {
        when(casePath, !=, value, send: effects)
    }
}
