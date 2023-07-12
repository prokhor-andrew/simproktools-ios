//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate



public struct SceneBuilder<Trigger, Effect> {

    private let _function: (Scene<Trigger, Effect>) -> Scene<Trigger, Effect>

    public init() {
        _function = { $0 }
    }

    private init(_ function: @escaping (Scene<Trigger, Effect>) -> Scene<Trigger, Effect>) {
        self._function = function
    }
    
    public func handle(
        function: @escaping (Scene<Trigger, Effect>) -> Scene<Trigger, Effect>
    ) -> SceneBuilder<Trigger, Effect> {
        SceneBuilder {
            _function(function($0))
        }
    }
    
    public func build(_ supplier: @autoclosure () -> Scene<Trigger, Effect>) -> Scene<Trigger, Effect> {
        _function(supplier())
    }
}
