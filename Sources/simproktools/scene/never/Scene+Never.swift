//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    static func never(doOn: @escaping ((Message) -> Void) -> Void = { _ in }) -> Scene<Trigger, Effect, Message> {
        Scene { _, logger in
            doOn(logger)
            return SceneTransition(never(doOn: doOn))
        }
    }
}
