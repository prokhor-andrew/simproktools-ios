//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func never(doOnTrigger: @escaping (StoryExtras) -> Void = { _ in }) -> Story<Event> {
        Story { extras, event in
            doOnTrigger(extras)
            return nil
        }
    }
}
