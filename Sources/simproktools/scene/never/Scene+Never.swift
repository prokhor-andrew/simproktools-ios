//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public extension Scene {

    static func never(doOn: @escaping ((Loggable) -> Void) -> Void = { _ in }) -> Scene<Trigger, Effect> {
        Scene { _, logger in
            doOn(logger)
            return SceneTransition(never(doOn: doOn))
        }
    }
}
