//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate


public extension Scene {

    static func split(_ scenes: Set<Scene<Trigger, Effect>>) -> Scene<Trigger, Effect> {
        func isFinale() -> Bool {
            for scene in scenes {
                if !scene.isFinale {
                    return false
                }
            }

            return true
        }

        if isFinale() {
            return .finale()
        }

        return Scene.create { trigger in
            for scene in scenes {
                if let transit = scene.transit,
                    let result = transit(trigger) {
                    return result
                }
            }

            return nil
        }
    }

    static func split(_ scenes: Scene<Trigger, Effect>...) -> Scene<Trigger, Effect> {
        split(Set(scenes))
    }

    func or(_ scenes: Set<Scene<Trigger, Effect>>) -> Scene<Trigger, Effect> {
        Scene.split(scenes.union([self]))
    }

    func or(_ scenes: Scene<Trigger, Effect>...) -> Scene<Trigger, Effect> {
        or(Set(scenes))
    }
}
