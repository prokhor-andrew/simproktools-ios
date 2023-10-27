//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 27.10.2023.
//

import simprokstate


public extension Scene {

    
    static func mergeFinaleOnCondition(
        _ scenes: [Scene<Trigger, Effect>],
        function: @escaping ([Bool]) -> Bool
    ) -> Scene<Trigger, Effect> {
        assert(scenes.hasDuplicates, "scenes must not contain duplicates")
        
        if function(scenes.map(\.isFinale)) {
            return .finale()
        }

        return Scene.create { trigger in
            var effects: [Effect] = []
            
            let mapped = scenes.map { scene in
                if let transit = scene.transit {
                    if let transition = transit(trigger) {
                        effects.append(contentsOf: transition.effects)
                        return transition.state
                    } else {
                        return scene
                    }
                } else {
                    return scene
                }
            }
            
            return SceneTransition(mergeFinaleOnCondition(mapped, function: function), effects: effects)
        }
    }
    
    static func mergeFinaleOnCondition(
        _ scenes: Scene<Trigger, Effect>...,
        function: @escaping ([Bool]) -> Bool
    ) -> Scene<Trigger, Effect> {
        mergeFinaleOnCondition(scenes, function: function)
    }
}


fileprivate extension Array where Element: Equatable {
    
    var hasDuplicates: Bool {
        var copy = [Element]()
        
        for item in self {
            if copy.contains(item) {
                return true
            }
            copy.append(item)
        }
        
        return false
    }
}
