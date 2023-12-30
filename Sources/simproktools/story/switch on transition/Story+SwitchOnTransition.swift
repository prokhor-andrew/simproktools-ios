//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Story {
    
    func switchOnTransition<SubPayload, SubEvent>(
        function: @escaping (Story<Payload, Event>, Event) -> Story<Either<Payload, SubPayload>, Either<Event, SubEvent>>?
    ) -> Story<Either<Payload, SubPayload>, Either<Event, SubEvent>> {
        Story<Either<Payload, SubPayload>, Either<Event, SubEvent>>(payload: .left(payload)) { extras, event in
            switch event {
            case .left(let event):
                if let newStory = transit(event, extras.machineId, extras.logger) {
                    if let result = function(newStory, event) {
                        result
                    } else {
                        newStory.switchOnTransition(function: function)
                    }
                } else {
                    nil
                }
            case .right: nil
            }
        }
    }
}


public extension Story {
    
    static func switchBetween<LState, LEvent, RState, REvent>(
        leftStory: @autoclosure @escaping () -> Story<LState, LEvent>,
        rightStory: @autoclosure @escaping () -> Story<RState, REvent>,
        fromLeftToRight: @escaping (Story<LState, LEvent>, LEvent) -> Bool,
        fromRightToLeft: @escaping (Story<RState, REvent>, REvent) -> Bool
    ) -> Story<Payload, Event> where Payload == Either<LState, RState>, Event == Either<LEvent, REvent> {
        func original() -> Story<Payload, Event> {
            leftStory().switchOnTransition { story, event in
                if fromLeftToRight(story, event) {
                    rightStory().switchOnTransition { story, event -> Story<Either<RState, LState>, Either<REvent, LEvent>>? in
                        if fromRightToLeft(story, event) {
                            original().mapPayload { either in
                                switch either {
                                case .left(let val): .right(val)
                                case .right(let val): .left(val)
                                }
                            }.mapEvent { _, event in
                                switch event {
                                case .left(let val): [.right(val)]
                                case .right(let val): [.left(val)]
                                }
                            }
                        } else {
                            nil
                        }
                    }.mapPayload { payload in
                        switch payload {
                        case .left(let val): .right(val)
                        case .right(let val): .left(val)
                        }
                    }.mapEvent { _, event in
                        switch event {
                        case .left(let val): [.right(val)]
                        case .right(let val): [.left(val)]
                        }
                    }
                } else {
                    nil
                }
            }
        }
        
        return original()
    }
}



public extension Story {
    
    func attach<MainLeftPayload, MainLeftEvent, MainRightPayload, MainRightEvent, SubLeftPayload, SubLeftEvent, SubRightPayload, SubRightEvent>(
        left: @autoclosure @escaping () -> Story<SubLeftPayload, SubLeftEvent>,
        right: @autoclosure @escaping () -> Story<SubRightPayload, SubRightEvent>
    ) -> Story<Either<(MainLeftPayload, SubLeftPayload), (MainRightPayload, SubRightPayload)>, Either<Event, Either<SubLeftEvent, SubRightEvent>>> where Payload == Either<MainLeftPayload, MainRightPayload>, Event == Either<MainLeftEvent, MainRightEvent> {
        
        let currentPayload: Either<(MainLeftPayload, SubLeftPayload), (MainRightPayload, SubRightPayload)> =
            switch payload {
            case .left(let val): .left((val, left().payload))
            case .right(let val): .right((val, right().payload))
            }
        
        
        return Story<Either<(MainLeftPayload, SubLeftPayload), (MainRightPayload, SubRightPayload)>, Either<Event, Either<SubLeftEvent, SubRightEvent>>>(payload: currentPayload) { extras, event in
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
