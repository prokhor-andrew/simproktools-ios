//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 26.11.2023.
//

import simprokstate
import CasePaths


public func waiting<Whole, Part>(
    for keyPath: KeyPath<Whole, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part
) -> (Whole) -> Bool {
    { function($0[keyPath: keyPath], value) }
}

public func waiting<Whole: CasePathable, Part>(
    for casePath: CaseKeyPath<Whole, Part>,
    to function: @escaping (Part, Part) -> Bool,
    value: Part
) -> (Whole) -> Bool {
    {
        if let part = $0[case: casePath] {
            function(part, value)
        } else {
            false
        }
    }
}


infix operator => : AssignmentPrecedence
infix operator !> : AssignmentPrecedence


public func =><Event>(
    lhs: @escaping (Event) -> Bool,
    rhs: @autoclosure @escaping () -> Story<Event>
) -> Story<Event> {
    Story { extras, event in lhs(event) ? rhs() : nil }
}

public func =><Event>(
    lhs: @escaping (Event) -> Bool,
    rhs: @escaping () -> Story<Event>
) -> Story<Event> {
    lhs => rhs()
}

public func !><Event>(
    lhs: @escaping (Event) -> Bool,
    rhs: @autoclosure @escaping () -> Story<Event>
) -> Story<Event> {
    Story { extras, event in !lhs(event) ? rhs() : nil }
}

public func !><Event>(
    lhs: @escaping (Event) -> Bool,
    rhs: @escaping () -> Story<Event>
) -> Story<Event> {
    lhs !> rhs()
}
