//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokstate

public extension Feature {

    static func finale() -> Feature<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        Feature.finale(SetOfMachines())
    }
}
