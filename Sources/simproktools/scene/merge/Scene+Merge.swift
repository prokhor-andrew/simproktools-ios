//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Scene {

    // isFinaleChecked added to remove unnecessary loops
    private static func merge(isFinaleChecked: Bool, scenes: Set<Scene<Trigger, Effect>>) -> Scene<Trigger, Effect> {
        if !isFinaleChecked {
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
        }

        return Scene.create { trigger in
            var isFinale = true

            var effects: [Effect] = []

            let mapped = Set(scenes.map { scene in
                if let transit = scene.transit {
                    isFinale = false
                    let transition = transit(trigger)
                    effects.append(contentsOf: transition.effects)
                    return transition.state
                } else {
                    return scene
                }
            })

            if isFinale {
                return SceneTransition(.finale())
            } else {
                return SceneTransition(merge(isFinaleChecked: true, scenes: mapped), effects: effects)
            }
        }
    }

    static func merge(_ scenes: Set<Scene<Trigger, Effect>>) -> Scene<Trigger, Effect> {
        merge(isFinaleChecked: false, scenes: scenes)
    }

    static func merge(_ scenes: Scene<Trigger, Effect>...) -> Scene<Trigger, Effect> {
        merge(Set(scenes))
    }

    func and(_ scenes: Set<Scene<Trigger, Effect>>) -> Scene<Trigger, Effect> {
        .merge(scenes.union([self]))
    }

    func and(_ scenes: Scene<Trigger, Effect>...) -> Scene<Trigger, Effect> {
        and(Set(scenes))
    }
}