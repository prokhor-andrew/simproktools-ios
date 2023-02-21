//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public extension Outline {

    private static func handle(
            dict: [String: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>],
            id: String,
            data: FeatureEvent<IntTrigger, ExtTrigger>,
            function: @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> ([String: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>], [FeatureEvent<IntEffect, ExtEffect>]) {
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
                    return (copy, effects: effects)
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

    static func dynamic(
            _ function: @escaping () -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>
    ) -> Outline<IdEvent<IntTrigger>, IdEvent<IntEffect>, IdEvent<ExtTrigger>, IdEvent<ExtEffect>> {
        Outline<IdEvent<IntTrigger>, IdEvent<IntEffect>, IdEvent<ExtTrigger>, IdEvent<ExtEffect>>
                .classic([String: Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect>]()) { dict, trigger in

                    switch trigger {
                    case .int(let value):

                        let (dict, effects) = handle(
                                dict: dict,
                                id: value.id,
                                data: .int(value.event),
                                function: function
                        )

                        return (
                                dict,
                                effects.map {
                                    switch $0 {
                                    case .int(let v):
                                        return .int(IdEvent(id: value.id, event: v))
                                    case .ext(let v):
                                        return .ext(IdEvent(id: value.id, event: v))
                                    }
                                }
                        )
                    case .ext(let value):
                        let (dict, effects) = handle(
                                dict: dict,
                                id: value.id,
                                data: .ext(value.event),
                                function: function
                        )

                        return (
                                dict,
                                effects.map {
                                    switch $0 {
                                    case .int(let v):
                                        return .int(IdEvent(id: value.id, event: v))
                                    case .ext(let v):
                                        return .ext(IdEvent(id: value.id, event: v))
                                    }
                                }
                        )
                    }
                }
    }
}
