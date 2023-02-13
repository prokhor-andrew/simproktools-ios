//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func never() -> Story<Event> {
        Story { _ in
            nil
        }
    }
}