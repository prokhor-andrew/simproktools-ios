//
// Created by Andriy Prokhorenko on 12.02.2023.
//

import simprokstate

public struct StoryBuilder<Event, Message> {

    private let _function: (Story<Event, Message>) -> Story<Event, Message>

    public init() {
        _function = { $0 }
    }

    private init(_ function: @escaping (Story<Event, Message>) -> Story<Event, Message>) {
        self._function = function
    }
    
    public func handle(
        function: @escaping (Story<Event, Message>) -> Story<Event, Message>
    ) -> StoryBuilder<Event, Message> {
        StoryBuilder {
            _function(function($0))
        }
    }
    
    public func build(_ supplier: @autoclosure () -> Story<Event, Message>) -> Story<Event, Message> {
        _function(supplier())
    }
}
