//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {


    static func never() -> Scene<Trigger, Effect> {
        Scene.create { _ in
            nil
        }
    }
}
