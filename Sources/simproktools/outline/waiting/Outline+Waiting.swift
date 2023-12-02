//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 01.12.2023.
//

import simprokstate
import CasePaths


public func waiting<Part, IntTrigger, ExtTrigger, IntEffect, ExtEffect>(
    for casePath: CaseKeyPath<FeatureEvent<IntTrigger, ExtTrigger>, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [FeatureEvent<IntEffect, ExtEffect>]
) -> (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]? {
    {
        if let unwrapped = $0[case: casePath], function(unwrapped, value) {
            effects
        } else {
            nil
        }
    }
}

public func waiting<Part, IntTrigger, IntEffect, ExtTrigger, ExtEffect>(
    forInt keyPath: KeyPath<IntTrigger, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [FeatureEvent<IntEffect, ExtEffect>]
) -> (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]? {
    {
        if let unwrapped = $0[case: \.int], function(unwrapped[keyPath: keyPath], value) {
            effects
        } else {
            nil
        }
    }
}

public func waiting<Part, IntTrigger: CasePathable, IntEffect, ExtTrigger, ExtEffect>(
    forInt casePath: CaseKeyPath<IntTrigger, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [FeatureEvent<IntEffect, ExtEffect>]
) -> (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]? {
    {
        if let unwrapped = $0[case: \.int], let unwrapped2 = unwrapped[case: casePath], function(unwrapped2, value) {
            effects
        } else {
            nil
        }
    }
}

public func waiting<Part, IntTrigger, IntEffect, ExtTrigger, ExtEffect>(
    forExt keyPath: KeyPath<ExtTrigger, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [FeatureEvent<IntEffect, ExtEffect>]
) -> (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]? {
    {
        if let unwrapped = $0[case: \.ext], function(unwrapped[keyPath: keyPath], value) {
            effects
        } else {
            nil
        }
    }
}

public func waiting<Part, IntTrigger, IntEffect, ExtTrigger: CasePathable, ExtEffect>(
    forExt casePath: CaseKeyPath<ExtTrigger, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part,
    send effects: [FeatureEvent<IntEffect, ExtEffect>]
) -> (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]? {
    {
        if let unwrapped = $0[case: \.ext], let unwrapped2 = unwrapped[case: casePath], function(unwrapped2, value) {
            effects
        } else {
            nil
        }
    }
}


infix operator ===> : AssignmentPrecedence
infix operator !!!> : AssignmentPrecedence

public func ===><IntTrigger, IntEffect, ExtTrigger, ExtEffect>(
    lhs: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]?,
    rhs: @autoclosure @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
    @Sendable
    func outline() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { extras, trigger in
            if let effects = lhs(trigger) {
                OutlineTransition(rhs(), effects: effects)
            } else {
                OutlineTransition(outline())
            }
        }
    }
    
    return outline()
}

public func ===><IntTrigger, IntEffect, ExtTrigger, ExtEffect>(
    lhs: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]?,
    rhs: @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
    lhs ===> rhs()
}

public func !!!><IntTrigger, IntEffect, ExtTrigger, ExtEffect>(
    lhs: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]?,
    rhs: @autoclosure @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
    @Sendable
    func outline() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { extras, trigger in
            if let effects = lhs(trigger) {
                OutlineTransition(outline(), effects: effects)
            } else {
                OutlineTransition(rhs())
            }
        }
    }
    
    return outline()
}

public func !!!><IntTrigger, IntEffect, ExtTrigger, ExtEffect>(
    lhs: @escaping (FeatureEvent<IntTrigger, ExtTrigger>) -> [FeatureEvent<IntEffect, ExtEffect>]?,
    rhs: @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
    lhs !!!> rhs()
}


extension FeatureEvent: CasePathable {
    
    public struct AllCasePaths {
        var int: AnyCasePath<FeatureEvent<Internal, External>, Internal> {
          AnyCasePath(
            embed: { .int($0) },
            extract: {
                guard case let .int(value) = $0 else { return nil }
                return value
            }
          )
        }
        
        var ext: AnyCasePath<FeatureEvent<Internal, External>, External> {
          AnyCasePath(
            embed: { .ext($0) },
            extract: {
                guard case let .ext(value) = $0 else { return nil }
                return value
            }
          )
        }
    }


    public static var allCasePaths: AllCasePaths { AllCasePaths() }
}
