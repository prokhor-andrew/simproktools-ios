//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 26.11.2023.
//

import simprokstate
import CasePaths


public func waiting<Whole, Part, Effect>(
    for keyPath: KeyPath<Whole, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [Effect]
) -> (Whole) -> [Effect]? {
    { function($0[keyPath: keyPath], value) ? effects : nil }
}

public func waiting<Whole: CasePathable, Part, Effect>(
    for casePath: CaseKeyPath<Whole, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [Effect]
) -> (Whole) -> [Effect]? {
    {
        if let part = $0[case: casePath] {
            function(part, value) ? effects : nil
        } else {
            nil
        }
    }
}


infix operator ==> : AssignmentPrecedence
infix operator !!> : AssignmentPrecedence


public func ==><Trigger, Effect>(
    lhs: @escaping (Trigger) -> [Effect]?,
    rhs: @autoclosure @escaping () -> Scene<Trigger, Effect>
) -> Scene<Trigger, Effect> {
    @Sendable
    func scene() -> Scene<Trigger, Effect> {
        Scene { extras, trigger in
            if let effects = lhs(trigger) {
                SceneTransition(rhs(), effects: effects)
            } else {
                SceneTransition(scene())
            }
        }
    }
    
    return scene()
}

public func ==><Trigger, Effect>(
    lhs: @escaping (Trigger) -> [Effect]?,
    rhs: @escaping () -> Scene<Trigger, Effect>
) -> Scene<Trigger, Effect> {
    lhs ==> rhs()
}

public func !!><Trigger, Effect>(
    lhs: @escaping (Trigger) -> [Effect]?,
    rhs: @autoclosure @escaping () -> Scene<Trigger, Effect>
) -> Scene<Trigger, Effect> {
    @Sendable
    func scene() -> Scene<Trigger, Effect> {
        Scene { extras, trigger in
            if let effects = lhs(trigger) {
                SceneTransition(scene(), effects: effects)
            } else {
                SceneTransition(rhs())
            }
        }
    }
    
    return scene()
}

public func !!><Trigger, Effect>(
    lhs: @escaping (Trigger) -> [Effect]?,
    rhs: @escaping () -> Scene<Trigger, Effect>
) -> Scene<Trigger, Effect> {
    lhs !!> rhs()
}
