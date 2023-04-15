//
// Created by Andriy Prokhorenko on 12.02.2023.
//

import simprokmachine
import simprokstate

public struct StoryBuilder<Event> {

    private let _function: Mapper<Story<Event>, Story<Event>>

    public init() {
        _function = { $0 }
    }

    private init(_ function: @escaping Mapper<Story<Event>, Story<Event>>) {
        self._function = function
    }
    
    public func handle(
        function: @escaping Mapper<Story<Event>, Story<Event>>
    ) -> StoryBuilder<Event> {
        StoryBuilder {
            _function(function($0))
        }
    }
    
    public func build(_ supplier: @autoclosure Supplier<Story<Event>>) -> Story<Event> {
        _function(supplier())
    }
}
