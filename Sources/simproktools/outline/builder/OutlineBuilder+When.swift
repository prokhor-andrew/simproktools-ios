//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokstate
import CasePaths

public extension OutlineBuilder {
    
    func when(
        _ function: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]?
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        handle { state in
            
            @Sendable
            func currentState() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
                Outline { extras, trigger in
                    if let effects = function(trigger) {
                        return OutlineTransition(
                            state,
                            effects: effects
                        )
                    } else {
                        return OutlineTransition(currentState())
                    }
                }
            }
            
            return currentState()
        }
    }
    
    func when(
        _ operation: @escaping (FeatureEvent<IntTrigger, ExtTrigger>, FeatureEvent<IntTrigger, ExtTrigger>) -> Bool,
        _ value: FeatureEvent<IntTrigger, ExtTrigger>,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            operation($0, value) ? effects : nil
        }
    }
    
    func when(
        _ operation: @escaping (FeatureEvent<IntTrigger, ExtTrigger>, FeatureEvent<IntTrigger, ExtTrigger>) -> Bool,
        _ value: FeatureEvent<IntTrigger, ExtTrigger>,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(operation, value, send: effects)
    }
}

public extension OutlineBuilder where IntTrigger: Equatable, ExtTrigger: Equatable {
    
    func when(
        is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(==, trigger, send: effects)
    }

    func when(
        is trigger:  FeatureEvent<IntTrigger, ExtTrigger>,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(is: trigger, send: effects)
    }

    func when(
        not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(!=, trigger, send: effects)
    }

    func when(
        not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(not: trigger, send: effects)
    }
}


public extension OutlineBuilder {
    
    func when<T>(
        int keyPath: KeyPath<IntTrigger, T>,
        function: @escaping (T) -> [FeatureEvent<IntEffect, ExtEffect>]?
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            switch $0 {
            case .int(let val):
                return function(val[keyPath: keyPath])
            case .ext:
                return nil
            }
        }
    }
    
    func when<T>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        function: @escaping (T) -> [FeatureEvent<IntEffect, ExtEffect>]?
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            switch $0 {
            case .int:
                return nil
            case .ext(let val):
                return function(val[keyPath: keyPath])
            }
        }
    }
    
    func when<T>(
        int keyPath: KeyPath<IntTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: keyPath) {
            operation($0, value) ? effects : nil
        }
    }
    
    func when<T>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: keyPath) {
            operation($0, value) ? effects : nil
        }
    }
    
    func when<T>(
        int keyPath: KeyPath<IntTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: keyPath, operation, value, send: effects)
    }
    
    func when<T>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: keyPath, operation, value, send: effects)
    }
    
    func when<T: Equatable>(
        int keyPath: KeyPath<IntTrigger, T>,
        is value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        is value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        int keyPath: KeyPath<IntTrigger, T>,
        is value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        is value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: keyPath, ==, value, send: effects)
    }
    
    func when<T: Equatable>(
        int keyPath: KeyPath<IntTrigger, T>,
        not value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: keyPath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        not value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: keyPath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        int keyPath: KeyPath<IntTrigger, T>,
        not value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: keyPath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        ext keyPath: KeyPath<ExtTrigger, T>,
        not value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: keyPath, !=, value, send: effects)
    }
}

public extension OutlineBuilder where IntTrigger: CasePathable {
    
    func when<T>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        function: @escaping (T) -> [FeatureEvent<IntEffect, ExtEffect>]?
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            switch $0 {
            case .int(let val):
                if let val = val[case: casePath] {
                    function(val)
                } else {
                    nil
                }
            case .ext:
                nil
            }
        }
    }
    
    
    func when<T>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: casePath) {
            operation($0, value) ? effects : nil
        }
    }
    
    
    func when<T>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: casePath, operation, value, send: effects)
    }
    
    func when<T: Equatable>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        is value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: casePath, ==, value, send: effects)
    }
    
    
    func when<T: Equatable>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        is value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: casePath, ==, value, send: effects)
    }
    func when<T: Equatable>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        not value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: casePath, !=, value, send: effects)
    }
    
    func when<T: Equatable>(
        int casePath: CaseKeyPath<IntTrigger, T>,
        not value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(int: casePath, !=, value, send: effects)
    }
}

public extension OutlineBuilder where ExtTrigger: CasePathable {
    

    
    func when<T>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        function: @escaping (T) -> [FeatureEvent<IntEffect, ExtEffect>]?
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            switch $0 {
            case .int:
                nil
            case .ext(let val):
                if let val = val[case: casePath] {
                    function(val)
                } else {
                    nil
                }
            }
        }
    }

    func when<T>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: casePath) {
            operation($0, value) ? effects : nil
        }
    }
    
    func when<T>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        _ operation: @escaping (T, T) -> Bool,
        _ value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: casePath, operation, value, send: effects)
    }

    func when<T: Equatable>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        is value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: casePath, ==, value, send: effects)
    }
    
        
    func when<T: Equatable>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        is value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: casePath, ==, value, send: effects)
    }
    
    
    func when<T: Equatable>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        not value: T,
        send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: casePath, !=, value, send: effects)
    }
        
    func when<T: Equatable>(
        ext casePath: CaseKeyPath<ExtTrigger, T>,
        not value: T,
        send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(ext: casePath, !=, value, send: effects)
    }
}
