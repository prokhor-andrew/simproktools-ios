//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 08.04.2023.
//

import simprokmachine
import simprokstate


public extension Story {
    
    func switchTo(
        doneOnFinale: Bool = true,
        function: @escaping BiMapper<
            Story<Event>,
            Event,
            Story<Event>?
        >
    ) -> Story<Event> {
        if doneOnFinale {
            if let transit {
                return Story.create { trigger in
                    if let transition = function(self, trigger) {
                        return transition
                    } else {
                        if let transition = transit(trigger) {
                            return transition.switchTo(doneOnFinale: doneOnFinale, function: function)
                        } else {
                            return nil
                        }
                    }
                }
            } else {
                return .finale()
            }
        } else {
            return Story.create { trigger in
                if let transition = function(self, trigger) {
                    return transition
                } else {
                    if let transit, let transition = transit(trigger) {
                        return transition.switchTo(doneOnFinale: doneOnFinale, function: function)
                    } else {
                        return nil
                    }
                }
            }
        }
    }
}
