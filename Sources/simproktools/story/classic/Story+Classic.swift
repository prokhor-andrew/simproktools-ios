//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    static func classic<State>(
            _ initial: State,
            function: @escaping BiMapper<State, Event, ClassicStoryResult<State>>
    ) -> Story<Event> {
        Story.create {
            switch function(initial, $0) {
            case .skip:
                return nil
            case .finale:
                return .finale()
            case .next(let new):
                return classic(new, function: function)
            }
        }
    }
    
    static func classic(
        function: @escaping Mapper<Event, ClassicStatelessStoryResult>
    ) -> Story<Event> {
        classic(Void()) { state, trigger in
            switch function(trigger) {
            case .next:
                return .next(state)
            case .skip:
                return .skip
            case .finale:
                return .finale
            }
        }
    }
}
