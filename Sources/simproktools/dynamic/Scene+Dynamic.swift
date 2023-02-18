//
// Created by Andriy Prokhorenko on 18.02.2023.
//

import simprokstate


public extension Scene {

    static func dynamic(_ function: @escaping () -> Scene<Trigger, Effect>) -> Scene<IdEvent<Trigger>, IdEvent<Effect>> {
        Scene<IdEvent<Trigger>, IdEvent<Effect>>.classic([String: Scene<Trigger, Effect>]()) { dict, trigger in
            let id = trigger.id
            let data = trigger.event

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
                        return (copy, effects: effects.map { IdEvent(id: id, event: $0) })
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
                        return (copy, effects: effects.map { IdEvent(id: id, event: $0) })
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