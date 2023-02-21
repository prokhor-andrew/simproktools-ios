//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate


public extension Outline {

    static func never() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline.create { _ in
            OutlineTransition(never())
        }
    }
}