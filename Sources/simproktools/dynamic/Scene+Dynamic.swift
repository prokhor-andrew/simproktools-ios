//
// Created by Andriy Prokhorenko on 18.02.2023.
//
import simprokstate

public extension Scene {

    static func dynamic<Id: Hashable, T, E>(
        typeId _ : Id.Type,
        typeTrigger _ : T.Type,
        typeEffect _ : E.Type,
        function: @escaping (T) -> Scene<T, E>
    ) -> Scene<Trigger, Effect> where Trigger == IdData<Id, T>, Effect == IdData<Id, E> {
        .dynamic(function)
    }
    
    static func dynamic<Id: Hashable, T, E>(
        _ function: @escaping (T) -> Scene<T, E>
    ) -> Scene<Trigger, Effect> where Trigger == IdData<Id, T>, Effect == IdData<Id, E> {
        Scene.classic([Id: Scene<T, E>]()) { dict, trigger in
            let id = trigger.id
            let data = trigger.data
            
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
                        return (copy, effects: effects.map { IdData(id: id, data: $0) })
                    } else {
                        // no transition was executed
                        return (dict, effects: [])
                    }
                } else {
                    // IT IS FINALE
                    return (dict, effects: [])
                }
            } else {
                let old = function(data)
                if let transit = old.transit {
                    if let transition = transit(data) {
                        let new = transition.state
                        let effects = transition.effects

                        var copy = dict
                        copy[id] = new
                        return (copy, effects: effects.map { IdData(id: id, data: $0) })
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
