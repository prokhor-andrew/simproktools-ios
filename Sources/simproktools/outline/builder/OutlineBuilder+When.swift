//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 14.04.2023.
//

import simprokmachine
import simprokstate

public extension OutlineBuilder {
    
    func when(
            _ function: @escaping Mapper<FeatureEvent<IntTrigger, ExtTrigger>, [FeatureEvent<IntEffect, ExtEffect>]?>
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        handle { state in
            Outline.create {
                if let effects = function($0) {
                    return OutlineTransition(
                        state,
                        effects: effects
                    )
                } else {
                    return nil
                }
            }
        }
    }
}

public extension OutlineBuilder where IntTrigger: Equatable, ExtTrigger: Equatable {
    
    func when(
            is trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            if $0 == trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    func when(
            is trigger:  FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(is: trigger, send: effects)
    }

    func when(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: [FeatureEvent<IntEffect, ExtEffect>]
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when {
            if $0 != trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    func when(
            not trigger: FeatureEvent<IntTrigger, ExtTrigger>,
            send effects: FeatureEvent<IntEffect, ExtEffect>...
    ) -> OutlineBuilder<IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
        when(not: trigger, send: effects)
    }
}
