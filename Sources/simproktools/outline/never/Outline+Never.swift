//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate


public extension Outline {

    static func never(doOn: @escaping ((Loggable) -> Void) -> Void = { _ in }) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Outline { extras, trigger in
            doOn(extras.logger)
            return OutlineTransition(never(doOn: doOn))
        }
    }
}
