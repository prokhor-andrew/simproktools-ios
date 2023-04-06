//
// Created by Andriy Prokhorenko on 19.02.2023.
//
import simprokstate

public extension Outline {

    private static func handle<Key: Hashable, IT, IE, ET, EE>(
            dict: [Key: Outline<IT, IE, ET, EE>],
            id: Key,
            data: FeatureEvent<IT, ET>,
            function: @escaping (FeatureEvent<IT, ET>) -> Outline<IT, IE, ET, EE>
    ) -> ([Key: Outline<IT, IE, ET, EE>], [FeatureEvent<IE, EE>]) {
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
            let old = function(data)
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
        Id: Hashable, IT, IE, ET, EE
    >(
        typeId _ : Id.Type,
        typeIntTrigger _ : IT.Type,
        typeIntEffect _ : IE.Type,
        typeExtTrigger _ : ET.Type,
        typeExtEffect _ : EE.Type,
        function: @escaping (FeatureEvent<IT, ET>) -> Outline<IT, IE, ET, EE>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where
    IntTrigger == IdData<Id, IT>,
    IntEffect == IdData<Id, IE>,
    ExtTrigger == IdData<Id, ET>,
    ExtEffect == IdData<Id, EE> {
        .dynamic(function)
    }
    
    static func dynamic<
        Id: Hashable, IT, IE, ET, EE
    >(
        _ function: @escaping (FeatureEvent<IT, ET>) -> Outline<IT, IE, ET, EE>
    ) -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where
    IntTrigger == IdData<Id, IT>,
    IntEffect == IdData<Id, IE>,
    ExtTrigger == IdData<Id, ET>,
    ExtEffect == IdData<Id, EE> {
        Outline.classic([Id: Outline<IT, IE, ET, EE>]()) { dict, trigger in
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
                            return .int(IdData(id: value.id, data: v))
                        case .ext(let v):
                            return .ext(IdData(id: value.id, data: v))
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
                            return .int(IdData(id: value.id, data: v))
                        case .ext(let v):
                            return .ext(IdData(id: value.id, data: v))
                        }
                    }
                )
            }
        }
    }
}
