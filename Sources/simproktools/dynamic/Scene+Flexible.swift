//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 18.03.2023.
//

import simprokstate


public enum SceneFlexibleEvent<Trigger, Effect> {
    case create(SceneTransition<Trigger, Effect>)
    case normal(Trigger)
}

public extension Scene {
    
    
    static func flexible<
        T, E,
        Id: Hashable
    >(
    ) -> Scene<Trigger, Effect> where
    Trigger: DynamicEvent,
    Effect: DynamicEvent,
    Trigger.Data == SceneFlexibleEvent<T, E>,
    Effect.Data == E,
    Trigger.Id == Id,
    Effect.Id == Id {
        func create(
            dict: [Id: Scene<T, E>],
            id: Id,
            transition: SceneTransition<T, E>
        ) -> ([Id: Scene<T, E>], [Effect]) {
            if dict[id] != nil {
                return (dict, [])
            } else {
                if transition.state.isFinale {
                    return (dict, transition.effects.map {
                        Effect(id: id, data: $0)
                    })
                } else {
                    var copy = dict
                    copy[id] = transition.state
                    
                    return (copy, transition.effects.map {
                        Effect(id: id, data: $0)
                    })
                }
            }
        }
        
        func normal(
                dict: [Id: Scene<T, E>],
                id: Id,
                data: T
        ) -> ([Id: Scene<T, E>], [Effect]) {
            if let state = dict[id] {
                if let transit = state.transit {
                    let transition = transit(data)
                    
                    if transition.state.id == state.id {
                        // there was no transition
                        return (dict, [])
                    } else {
                        var copy = dict
                        copy[id] = transition.state
                        return (copy, transition.effects.map {
                            Effect(id: id, data: $0)
                        })
                    }
                } else {
                    // finale. it should not be there, but if it is there, let's remove it
                    var copy = dict
                    copy[id] = nil
                    return (copy, [])
                }
            } else {
                return (dict, [])
            }
        }
        

        return Scene.classic([Id: Scene<T, E>]()) { dict, trigger in
            let id = trigger.id
            switch trigger.data {
            case .create(let transition):
                return create(dict: dict, id: id, transition: transition)
            case .normal(let data):
                return normal(dict: dict, id: id, data: data)
            }
        }
    }
}
