//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate


public extension SceneBuilder {
    
    func when(
        _ function: @escaping (Trigger) -> [Effect]?
    ) -> SceneBuilder<Trigger, Effect> {
        handle { state in
            Scene.create {
                if let effects = function($0) {
                    return SceneTransition(
                        state,
                        effects: effects
                    )
                } else {
                    return nil
                }
            }
        }
    }
    
    func when(
        _ operation: @escaping (Trigger, Trigger) -> Bool,
        _ value: Trigger,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when {
            operation($0, value) ? effects : nil
        }
    }
    
    func when(
        _ operation: @escaping (Trigger, Trigger) -> Bool,
        _ value: Trigger,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(operation, value, send: effects)
    }
}


public extension SceneBuilder where Trigger: Equatable {
    
    func when(
            is trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when(==, trigger, send: effects)
    }

    func when(
            is trigger: Trigger,
            send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(is: trigger, send: effects)
    }

    func when(
            not trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when(!=, trigger, send: effects)
    }

    func when(
            not trigger: Trigger,
            send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(not: trigger, send: effects)
    }
}


public extension SceneBuilder {
    
    func when<T>(
        _ keyPath: KeyPath<Trigger, T>,
        function: @escaping (T) -> [Effect]?
    ) -> SceneBuilder<Trigger, Effect> {
        when {
            function($0[keyPath: keyPath])
        }
    }
    
    func when<T>(
        _ keyPath: KeyPath<Trigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when(keyPath) {
            operation($0, value) ? effects : nil
        }
    }
    
    func when<T>(
        _ keyPath: KeyPath<Trigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(keyPath, operation, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        is value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when(keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        is value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        not value: T,
        send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> {
        when(keyPath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        _ keyPath: KeyPath<Trigger, T>,
        not value: T,
        send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> {
        when(keyPath, !=, value, send: effects)
    }
}
