//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 03.04.2023.
//

import simprokstate


public extension Story {
    
    func switchOnTransition<SubPayload, SubEvent>(
        function: @escaping (Story<Payload, Event, Loggable>, Event) -> Story<Either<Payload, SubPayload>, Either<Event, SubEvent>, Loggable>?
    ) -> Story<Either<Payload, SubPayload>, Either<Event, SubEvent>, Loggable> {
        Story<Either<Payload, SubPayload>, Either<Event, SubEvent>, Loggable>(payload: .left(payload)) { extras, event in
            switch event {
            case .left(let event):
                if let newStory = transit(event, extras.machineId, extras.logger) {
                    function(newStory, event) ?? newStory.switchOnTransition(function: function)
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
        leftStory: @autoclosure @escaping () -> Story<LState, LEvent, Loggable>,
        rightStory: @autoclosure @escaping () -> Story<RState, REvent, Loggable>,
        fromLeftToRight: @escaping (Story<LState, LEvent, Loggable>, LEvent) -> Bool,
        fromRightToLeft: @escaping (Story<RState, REvent, Loggable>, REvent) -> Bool
    ) -> Story<Payload, Event, Loggable> where Payload == Either<LState, RState>, Event == Either<LEvent, REvent> {
        func original() -> Story<Payload, Event, Loggable> {
            leftStory().switchOnTransition { story, event in
                if fromLeftToRight(story, event) {
                    rightStory().switchOnTransition { story, event -> Story<Either<RState, LState>, Either<REvent, LEvent>, Loggable>? in
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
