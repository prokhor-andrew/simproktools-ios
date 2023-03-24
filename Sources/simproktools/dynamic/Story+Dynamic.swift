

import simprokstate

public extension Story {

    static func dynamic<DE: DynamicEvent>(
        _ function: @escaping () -> Story<Event>
    ) -> Story<DE> where DE.Data == Event {
        Story<DE>.classic([DE.Id: Story<Event>]()) { dict, trigger in
            let id = trigger.id
            let data = trigger.data

            if let old = dict[id] {
                if let transit = old.transit {
                    if let new = transit(data) {
                        var copy = dict
                        if new.isFinale {
                            copy[id] = nil
                        } else {
                            copy[id] = new
                        }
                        return .next(copy)
                    } else {
                        // no transition was executed
                        return .skip
                    }
                } else {
                    // IT IS FINALE
                    return .skip
                }
            } else {
                let old = function()
                if let transit = old.transit {
                    if let new = transit(data) {
                        var copy = dict
                        copy[id] = new
                        return .next(copy)
                    } else {
                        // no transition was executed
                        return .skip
                    }
                } else {
                    // IT IS FINALE
                    return .skip
                }
            }
        }
    }
}
