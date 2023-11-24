//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokstate


public extension Story {
    
    func doOnGuard(function: @escaping @Sendable (Event) -> Void) -> Story<Event> {
        return Story { event in
            if let newStory = transit(event) {
                return newStory.doOnGuard(function: function)
            } else {
                function(event)
                return nil
            }
        }
    }
}
