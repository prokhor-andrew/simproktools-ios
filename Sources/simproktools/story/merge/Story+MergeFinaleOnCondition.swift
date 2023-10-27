//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 27.10.2023.
//

import simprokstate


public extension Story {

    
    static func mergeFinaleOnCondition(
        _ stories: [Story<Event>],
        function: @escaping ([Bool]) -> Bool
    ) -> Story<Event> {
        assert(stories.hasDuplicates, "stories must not contain duplicates")
        
        if function(stories.map(\.isFinale)) {
            return .finale()
        }

        return Story.create { trigger in
            let mapped = stories.map { story in
                if let transit = story.transit {
                    if let newStory = transit(trigger) {
                        return newStory
                    } else {
                        return story
                    }
                } else {
                    return story
                }
            } 
            
            return mergeFinaleOnCondition(mapped, function: function)
        }
    }
    
    static func mergeFinaleOnCondition(
        _ stories: Story<Event>...,
        function: @escaping ([Bool]) -> Bool
    ) -> Story<Event> {
        mergeFinaleOnCondition(stories, function: function)
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
