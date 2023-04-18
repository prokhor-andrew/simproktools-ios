//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Story {
    
    
    func switchOnTransition(
        to story: Story<Event>,
        doneOnFinale: Bool = true
    ) -> Story<Event> {
        if doneOnFinale {
            if let transit {
                if let storyTransit = story.transit {
                    return Story.create { trigger in
                        if let new = storyTransit(trigger) {
                            return new
                        } else {
                            if let new = transit(trigger) {
                                return new.switchOnTransition(to: story, doneOnFinale: doneOnFinale)
                            } else {
                                return nil
                            }
                        }
                    }
                } else {
                    return self
                }
            } else {
                return .finale()
            }
        } else {
            if let storyTransit = story.transit {
                return Story.create { trigger in
                    if let new = storyTransit(trigger) {
                        return new
                    } else {
                        if let transit {
                            if let new = transit(trigger) {
                                return new.switchOnTransition(to: story, doneOnFinale: doneOnFinale)
                            } else {
                                return nil
                            }
                        } else {
                            return nil
                        }
                    }
                }
            } else {
                return self
            }
        }
    }
}

