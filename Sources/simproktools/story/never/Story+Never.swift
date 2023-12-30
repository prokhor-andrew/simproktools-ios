//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    static func never(_ payload: Payload) -> Story<Payload, Event> {
        Story(payload: payload) { _,_ in nil }
    }
}
