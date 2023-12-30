//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    func mapEvent<R>(function: @escaping (Payload, R) -> [Event]) -> Story<Payload, R> {
        Story<Payload, R>(payload: payload) { extras, event in
            let (story, isTransitioned) = function(payload, event).reduce((self, false)) { partialResult, element in
                if let newStory = partialResult.0.transit(element, extras.machineId, extras.logger) {
                    (newStory, true)
                } else {
                    partialResult
                }
            }
            
            if isTransitioned {
                return story.mapEvent(function: function)
            } else {
                return nil
            }
        }
    }
}
