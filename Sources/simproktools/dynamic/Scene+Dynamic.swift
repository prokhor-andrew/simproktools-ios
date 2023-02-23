//
// Created by Andriy Prokhorenko on 18.02.2023.
//

import simprokstate

public extension Scene {

    static func dynamic<Id: Hashable, DynamicEventTrigger, DynamicEventEffect>(
        _ function: @escaping () -> Scene<Trigger, Effect>
    ) -> Scene<DynamicEventTrigger, DynamicEventEffect> where
    DynamicEventTrigger: DynamicEvent,
    DynamicEventEffect: DynamicEvent,
    DynamicEventTrigger.Data == Trigger,
    DynamicEventEffect.Data == Effect,
    DynamicEventTrigger.Id == Id,
    DynamicEventEffect.Id == Id
    {
        Scene<DynamicEventTrigger, DynamicEventEffect>.classic([Id: Scene<Trigger, Effect>]()) { dict, trigger in
            let id = trigger.id
            let data = trigger.data

            if let old = dict[id] {
                if let transit = old.transit {
                    let transition = transit(data)
                    let new = transition.state
                    let effects = transition.effects

                    if old != new {
                        var copy = dict
                        if new.isFinale {
                            copy[id] = nil
                        } else {
                            copy[id] = new
                        }
                        return (copy, effects: effects.map { DynamicEventEffect(id: id, data: $0) })
                    } else {
                        // no transition was executed
                        return (dict, effects: [])
                    }
                } else {
                    // IT IS FINALE
                    return (dict, effects: [])
                }
            } else {
                let old = function()
                if let transit = old.transit {
                    let transition = transit(data)
                    let new = transition.state
                    let effects = transition.effects

                    if old != new {
                        var copy = dict
                        copy[id] = new
                        return (copy, effects: effects.map { DynamicEventEffect(id: id, data: $0) })
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
    }
}
