//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func never(doOn: @escaping ((String) -> Void) -> Void = { _ in }) -> Story<Event> {
        Story { _, logger in
            doOn(logger)
            return nil
        }
    }
}
