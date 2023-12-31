//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokstate

public extension Story {

    func mapEvent<R>(function: @escaping (StoryExtras<Payload, Loggable>, R) -> [Event]) -> Story<Payload, R, Loggable> {
        Story<Payload, R, Loggable>(payload: payload) { extras, event in
            let (story, isTransitioned) = function(extras, event).reduce((self, false)) { partialResult, element in
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
