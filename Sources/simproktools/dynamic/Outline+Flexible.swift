//
//  Flexible.swift
//  
//
//  Created by Andriy Prokhorenko on 14.03.2023.
//

import simprokstate

public enum OutlineFlexibleEvent<Event, IntTrigger, IntEffect, ExtTrigger, ExtEffect> {
    case create(OutlineTransition<IntTrigger, IntEffect, ExtTrigger, ExtEffect>)
    case normal(Event)
}



public extension Outline {
    
    
    static func flexible<
        IT, IE, ET, EE,
        Id: Hashable
    >(
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where
    IntTrigger: DynamicEvent,
    IntEffect: DynamicEvent,
    ExtTrigger: DynamicEvent,
    ExtEffect: DynamicEvent,
    IntTrigger.Data == OutlineFlexibleEvent<IT, IT, IE, ET, EE>,
    ExtTrigger.Data == OutlineFlexibleEvent<ET, IT, IE, ET, EE>,
    IntEffect.Data == IE,
    ExtEffect.Data == EE,
    IntTrigger.Id == Id,
    IntEffect.Id == Id,
    ExtTrigger.Id == Id,
    ExtEffect.Id == Id {
        func create(
            dict: [Id: Outline<IT, IE, ET, EE>],
            id: Id,
            transition: OutlineTransition<IT, IE, ET, EE>
        ) -> ([Id: Outline<IT, IE, ET, EE>], [FeatureEvent<IntEffect, ExtEffect>]) {
            if dict[id] != nil {
                return (dict, [])
            } else {
                if transition.state.isFinale {
                    return (dict, transition.effects.map {
                        switch $0 {
                        case .int(let val):
                            return .int(IntEffect(id: id, data: val))
                        case .ext(let val):
                            return .ext(ExtEffect(id: id, data: val))
                        }
                    })
                } else {
                    var copy = dict
                    copy[id] = transition.state
                    
                    return (copy, transition.effects.map {
                        switch $0 {
                        case .int(let val):
                            return .int(IntEffect(id: id, data: val))
                        case .ext(let val):
                            return .ext(ExtEffect(id: id, data: val))
                        }
                    })
                }
            }
        }
        
        func normal(
                dict: [Id: Outline<IT, IE, ET, EE>],
                id: Id,
                data: FeatureEvent<IT, ET>
        ) -> ([Id: Outline<IT, IE, ET, EE>], [FeatureEvent<IntEffect, ExtEffect>]) {
            if let state = dict[id] {
                if let transit = state.transit {
                    if let transition = transit(data) {
                        var copy = dict
                        copy[id] = transition.state
                        return (copy, transition.effects.map {
                            switch $0 {
                            case .int(let val):
                                return .int(IntEffect(id: id, data: val))
                            case .ext(let val):
                                return .ext(ExtEffect(id: id, data: val))
                            }
                        })
                    } else {
                        // there was no transition
                        return (dict, [])
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
        
        return Outline.classic([Id: Outline<IT, IE, ET, EE>]()) { dict, trigger in
            switch trigger {
            case .int(let event):
                let id = event.id
                switch event.data {
                case .create(let transition):
                    return create(dict: dict, id: id, transition: transition)
                case .normal(let data):
                    return normal(dict: dict, id: id, data: .int(data))
                }
            case .ext(let event):
                let id = event.id
                switch event.data {
                case .create(let transition):
                    return create(dict: dict, id: id, transition: transition)
                case .normal(let data):
                    return normal(dict: dict, id: id, data: .ext(data))
                }
            }
        }
    }
}
