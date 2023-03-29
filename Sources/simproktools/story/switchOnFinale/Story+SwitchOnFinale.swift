//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.03.2023.
//

import simprokstate



public extension Story {
    
    
    func switchOnFinale(to story: Story<Event>) -> Story<Event> {
        guard let transit else {
            return .finale()
        }
      
        return Story.create { trigger in
            if let new = transit(trigger) {
                if new.isFinale {
                    return story
                } else {
                    return new.switchOnFinale(to: story)
                }
            } else {
                return nil
            }
        }
    }
}

