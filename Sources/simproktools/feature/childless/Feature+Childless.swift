//
// Created by Andriy Prokhorenko on 14.02.2023.
//

import simprokstate

public extension Feature {

    static func childless(
        transit: @escaping (ExtTrigger, (Message) -> Void) -> FeatureTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect, Message> {
        Feature.create(SetOfMachines()) { _, trigger, logger in
            switch trigger {
            case .int:
                // this is not supposed to ever happen as int event can come only from child machines
                // and this one does not have any
                return FeatureTransition(
                    childless(transit: transit)
                )
            case .ext(let value):
                return transit(value, logger)
            }
        }
    }

    var isChildless: Bool {
        machines.isEmpty
    }
}
