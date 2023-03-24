//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    private static func handle<Key: Hashable>(
            dict: [Key: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>],
            id: Key,
            data: FeatureEvent<IntTrigger, ExtTrigger>,
            function: @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> ([Key: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>], [FeatureEvent<IntEffect, ExtEffect>]) {
        if let old = dict[id] {
            if let transit = old.transit {
                if let transition = transit(data) {
                    let new = transition.state
                    let effects = transition.effects
                    var copy = dict
                    if new.isFinale {
                        copy[id] = nil
                    } else {
                        copy[id] = new
                    }
                    return (copy, effects: effects)
                } else {
                    // no transition was executed
                    return (dict, effects: [])
                }
            } else {
                // finale. it should not be there, but if it is there, let's remove it
                var copy = dict
                copy[id] = nil
                return (copy, effects: [])
            }
        } else {
            let old = function()
            if let transit = old.transit {
                if let transition = transit(data) {
                    let new = transition.state
                    let effects = transition.effects
                    var copy = dict
                    copy[id] = new
                    return (copy, effects: effects)
                } else {
                    // no transition was executed
                    return (dict, effects: [])
                }
            } else {
                // IT IS FINALE
                return (dict, effects: [])
            }
        }
    }

    static func dynamic<
        Id: Hashable,
        DynamicEventIntTrigger: DynamicEvent,
        DynamicEventIntEffect: DynamicEvent,
        DynamicEventExtTrigger: DynamicEvent,
        DynamicEventExtEffect: DynamicEvent
    >(
            _ function: @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> Outline<DynamicEventIntTrigger, DynamicEventIntEffect, DynamicEventExtTrigger, DynamicEventExtEffect> where
    DynamicEventIntTrigger.Data == IntTrigger,
    DynamicEventIntEffect.Data == IntEffect,
    DynamicEventExtTrigger.Data == ExtTrigger,
    DynamicEventExtEffect.Data == ExtEffect,
    DynamicEventIntTrigger.Id == Id,
    DynamicEventIntEffect.Id == Id,
    DynamicEventExtTrigger.Id == Id,
    DynamicEventExtEffect.Id == Id
    {
        Outline<DynamicEventIntTrigger, DynamicEventIntEffect, DynamicEventExtTrigger, DynamicEventExtEffect>
            .classic([Id: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>]()) { dict, trigger in
                    switch trigger {
                    case .int(let value):

                        let (dict, effects) = handle(
                                dict: dict,
                                id: value.id,
                                data: .int(value.data),
                                function: function
                        )

                        return (
                                dict,
                                effects.map {
                                    switch $0 {
                                    case .int(let v):
                                        return .int(DynamicEventIntEffect(id: value.id, data: v))
                                    case .ext(let v):
                                        return .ext(DynamicEventExtEffect(id: value.id, data: v))
                                    }
                                }
                        )
                    case .ext(let value):
                        let (dict, effects) = handle(
                                dict: dict,
                                id: value.id,
                                data: .ext(value.data),
                                function: function
                        )

                        return (
                                dict,
                                effects.map {
                                    switch $0 {
                                    case .int(let v):
                                        return .int(DynamicEventIntEffect(id: value.id, data: v))
                                    case .ext(let v):
                                        return .ext(DynamicEventExtEffect(id: value.id, data: v))
                                    }
                                }
                        )
                    }
                }
    }
}
