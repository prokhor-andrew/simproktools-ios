//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Story {
        
    // this functions tests event on param story every time, and once the transition happens
    // it switches to that story
    func switchOnTransition(
        to story: Story<Event>
    ) -> Story<Event> {
        Story { extras, event in
            if let new = story.transit(event, extras.logger) {
                return new
            } else {
                if let new = transit(event, extras.logger) {
                    return new.switchOnTransition(to: story)
                } else {
                    return nil
                }
            }
        }
    }
}

