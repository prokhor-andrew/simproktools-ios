//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate


public extension Scene {
    
    // isFinaleChecked added to remove unnecessary loops
    private static func merge2(
            isFinaleChecked: Bool,
            scenes: Set<Scene<Trigger, Effect>>
    ) -> Scene<Trigger, Effect> {
        if !isFinaleChecked {
            func isFinale() -> Bool {
                for scene in scenes {
                    if scene.isFinale {
                        return true
                    }
                }

                return false
            }

            if isFinale() {
                return .finale()
            }
        }

        return Scene.create { trigger in
            var isFinale = false

            var effects: [Effect] = []
            
            
            let mapped = Set(scenes.map { scene in
                if let transit = scene.transit {
                    if let transition = transit(trigger) {
                        effects.append(contentsOf: transition.effects)
                        if transition.state.isFinale {
                            isFinale = true
                        }
                        
                        return transition.state
                    } else {
                        return scene
                    }
                } else {
                    isFinale = true
                    return scene
                }
            })
            
            
            if isFinale {
                return SceneTransition(.finale(), effects: effects)
            } else {
                return SceneTransition(merge2(isFinaleChecked: true, scenes: mapped), effects: effects)
            }
        }
    }

    static func merge2(
            _ scenes: Set<Scene<Trigger, Effect>>
    ) -> Scene<Trigger, Effect> {
        merge2(isFinaleChecked: false, scenes: scenes)
    }
    
    static func merge2(
            _ scenes: Scene<Trigger, Effect>...
    ) -> Scene<Trigger, Effect> {
        merge2(Set(scenes))
    }

    func and2(
            _ scenes: Set<Scene<Trigger, Effect>>
    ) -> Scene<Trigger, Effect> {
        .merge2(scenes.union([self]))
    }

    func and2(
            _ scenes: Scene<Trigger, Effect>...
    ) -> Scene<Trigger, Effect> {
        and2(Set(scenes))
    }
}
