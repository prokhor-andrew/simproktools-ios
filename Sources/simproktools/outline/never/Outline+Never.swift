//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate


public extension Outline {

    static func never(doOn: @escaping ((String) -> Void) -> Void = { _ in }) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { _, logger in
            doOn(logger)
            return OutlineTransition(never(doOn: doOn))
        }
    }
}
