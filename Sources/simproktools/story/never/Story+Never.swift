//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func never(doOn: @escaping ((Message) -> Void) -> Void = { _ in }) -> Story<Event, Message> {
        Story { _, logger in
            doOn(logger)
            return nil
        }
    }
}
