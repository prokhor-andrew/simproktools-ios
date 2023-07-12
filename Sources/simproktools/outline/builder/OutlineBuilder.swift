//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokmachine
import simprokstate

public struct OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
 
    private let _function: (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    
    public init() {
        _function = { $0 }
    }
    
    private init(
        _function: @escaping (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) {
        self._function = _function
    }
    
    public func handle(
        function: @escaping (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        OutlineBuilder {
            _function(function($0))
        }
    }
    
    public func build(
        _ supplier: @autoclosure () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        _function(supplier())
    }
}
