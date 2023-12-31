//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 30.12.2023.
//

import simprokstate

public extension Story {
    
    func attach<MainLeftPayload, MainLeftEvent, MainRightPayload, MainRightEvent, SubLeftPayload, SubLeftEvent, SubRightPayload, SubRightEvent>(
        left: @autoclosure @escaping () -> Story<SubLeftPayload, SubLeftEvent, Loggable>,
        right: @autoclosure @escaping () -> Story<SubRightPayload, SubRightEvent, Loggable>
    ) -> Story<Either<(MainLeftPayload, SubLeftPayload), (MainRightPayload, SubRightPayload)>, Either<Event, Either<SubLeftEvent, SubRightEvent>>, Loggable> where Payload == Either<MainLeftPayload, MainRightPayload>, Event == Either<MainLeftEvent, MainRightEvent> {
        
        let currentPayload: Either<(MainLeftPayload, SubLeftPayload), (MainRightPayload, SubRightPayload)> =
            switch payload {
            case .left(let val): .left((val, left().payload))
            case .right(let val): .right((val, right().payload))
            }
        
        
        return Story<Either<(MainLeftPayload, SubLeftPayload), (MainRightPayload, SubRightPayload)>, Either<Event, Either<SubLeftEvent, SubRightEvent>>, Loggable>(payload: currentPayload) { extras, event in
            switch event {
            case .left(let main):
                if let newMainStory = transit(main, extras.machineId, extras.logger) {
                    newMainStory.attach(left: left(), right: right())
                } else {
                    nil
                }
            case .right(let sub):
                switch sub {
                case .left(let event):
                    if let newSubStory = left().transit(event, extras.machineId, extras.logger) {
                        attach(left: newSubStory, right: right())
                    } else {
                        nil
                    }
                    
                case .right(let event):
                    if let newSubStory = right().transit(event, extras.machineId, extras.logger) {
                        attach(left: left(), right: newSubStory)
                    } else {
                        nil
                    }
                }
            }
        }
    }
}
