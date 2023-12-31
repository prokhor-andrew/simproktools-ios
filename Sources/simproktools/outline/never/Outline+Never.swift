//
// Created by Andriy Prokhorenko on 19.02.2023.
//


import simprokstate

public extension Outline {

    static func never(_ payload: Payload) -> Outline<Payload, IntTrigger, IntEffect, ExtTrigger, ExtEffect, Loggable> {
        Outline(payload: payload) { extras, trigger in
            OutlineTransition(never(extras.payload))
        }
    }
}
