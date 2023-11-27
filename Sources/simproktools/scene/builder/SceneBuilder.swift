//
// Created by Andriy Prokhorenko on 17.02.2023.
//


import simprokstate


public struct SceneBuilder<Trigger, Effect, Message> {

    private let _function: (Scene<Trigger, Effect, Message>) -> Scene<Trigger, Effect, Message>

    public init() {
        _function = { $0 }
    }

    private init(_ function: @escaping (Scene<Trigger, Effect, Message>) -> Scene<Trigger, Effect, Message>) {
        self._function = function
    }
    
    public func handle(
        function: @escaping (Scene<Trigger, Effect, Message>) -> Scene<Trigger, Effect, Message>
    ) -> SceneBuilder<Trigger, Effect, Message> {
        SceneBuilder {
            _function(function($0))
        }
    }
    
    public func build(_ supplier: @autoclosure () -> Scene<Trigger, Effect, Message>) -> Scene<Trigger, Effect, Message> {
        _function(supplier())
    }
}
