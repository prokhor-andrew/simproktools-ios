//
// Created by Andriy Prokhorenko on 12.02.2023.
//

import simprokstate

public struct StoryBuilder<Event> {

    private let _function: (Story<Event>) -> Story<Event>

    public init() {
        _function = { $0 }
    }

    private init(_ function: @escaping (Story<Event>) -> Story<Event>) {
        self._function = function
    }
    
    public func handle(
        function: @escaping (Story<Event>) -> Story<Event>
    ) -> StoryBuilder<Event> {
        StoryBuilder {
            _function(function($0))
        }
    }
    
    public func build(_ supplier: @autoclosure () -> Story<Event>) -> Story<Event> {
        _function(supplier())
    }
}
