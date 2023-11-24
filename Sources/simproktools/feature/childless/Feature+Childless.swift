//
// Created by Andriy Prokhorenko on 14.02.2023.
//

import simprokstate

public extension Feature {

    static func childless(
        transit: @escaping (ExtTrigger) -> FeatureTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature.create(SetOfMachines()) { _, trigger in
            switch trigger {
            case .int:
                // this is not supposed to ever happen as int event can come only from child machines
                // and this one does not have any
                return FeatureTransition(
                    childless(transit: transit)
                )
            case .ext(let value):
                return transit(value)
            }
        }
    }

    var isChildless: Bool {
        machines.isEmpty
    }
}
