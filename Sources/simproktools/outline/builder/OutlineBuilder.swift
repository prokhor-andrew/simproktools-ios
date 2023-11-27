//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public struct OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
 
    private let _function: (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>
    
    public init() {
        _function = { $0 }
    }
    
    private init(
        _function: @escaping (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>
    ) {
        self._function = _function
    }
    
    public func handle(
        function: @escaping (Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        OutlineBuilder {
            _function(function($0))
        }
    }
    
    public func build(
        _ supplier: @autoclosure () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        _function(supplier())
    }
}
