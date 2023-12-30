//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 15.11.2023.
//

import simprokstate


public extension Story {
    
    func doAfterTransit(function: @escaping @Sendable (
        _ extras: StoryExtras<Payload>,
        _ event: Event,
        _ isTransitioned: Bool
    ) -> Void) -> Story<Payload, Event> {
        Story(payload: payload) { extras, event in
            if let newStory = transit(event, extras.machineId, extras.logger) {
                function(newStory.extras(machineId: extras.machineId, logger: extras.logger), event, true)
                return newStory.doAfterTransit(function: function)
            } else {
                function(extras, event, false)
                return nil
            }
        }
    }
}
