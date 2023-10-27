//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 27.10.2023.
//

import simprokstate


public extension Outline {

    
    static func mergeFinaleOnCondition(
        _ outlines: [Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>],
        function: @escaping ([Bool]) -> Bool
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        assert(outlines.hasDuplicates, "outlines must not contain duplicates")
        
        if function(outlines.map(\.isFinale)) {
            return .finale()
        }

        return Outline.create { trigger in
            var effects: [FeatureEvent<IntEffect, ExtEffect>] = []
            
            let mapped = outlines.map { outline in
                if let transit = outline.transit {
                    if let transition = transit(trigger) {
                        effects.append(contentsOf: transition.effects)
                        return transition.state
                    } else {
                        return outline
                    }
                } else {
                    return outline
                }
            }
            
            return OutlineTransition(mergeFinaleOnCondition(mapped, function: function), effects: effects)
        }
    }
    
    static func mergeFinaleOnCondition(
        _ outlines: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>...,
        function: @escaping ([Bool]) -> Bool
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        mergeFinaleOnCondition(outlines, function: function)
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
