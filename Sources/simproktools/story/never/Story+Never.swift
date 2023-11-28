//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func never(doOn: @escaping ((Loggable) -> Void) -> Void = { _ in }) -> Story<Event> {
        Story { _, logger in
            doOn(logger)
            return nil
        }
    }
}
