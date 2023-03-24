//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {
    
    static func source1<
        IntTrigger, IntEffect, State, Holder: AnyObject, Req: Hashable, Res, TriggerReason, CancelReason
    >(
        _ outlines: [Supplier<Outline<IntTrigger, IntEffect, Input, Output>>],
        initial: Supplier<State>,
        mapReq: @escaping BiMapper<State, IntEffect, (State, Either<TransformerOutput<TriggerReason, CancelReason, Req>, IntTrigger>?)>,
        mapRes: @escaping BiMapper<State, TransformerInput<TriggerReason, CancelReason, Res>, (State, Either<IntTrigger, TransformerOutput<TriggerReason, CancelReason, Req>>?)>,
        holder: @escaping Supplier<Holder>,
        onTrigger: @escaping TriHandler<Holder, Req, Handler<Res>>,
        onCancel: @escaping Handler<Holder>
    ) -> Machine<IdEvent<Input>, IdEvent<Output>> {
        
        let machine1: Machine<ExecuteInput<Req>, (Req, Res)> = Machine<ExecuteInput<Req>, (Req, Res)>(
                FeatureTransition<(Req, Res), Void, ExecuteInput<Req>, (Req, Res)>(
                        Feature.classic(MapOfMachines([:])) { machines, trigger in
                            switch trigger {
                            case .ext(let value):
                                switch value {
                                case .trigger(let isTriggerOnMain, let req):
                                    if machines.map[req] != nil {
                                        // ignore
                                        return (machines, [], false)
                                    } else {
                                        let machine: Machine<Void, (Req, Res)> = Machine<Void, Res>(holder(), isProcessOnMain: isTriggerOnMain) { object, input, callback in
                                            if input == nil {
                                                // do here
                                                onTrigger(object, req, callback)
                                            }
                                        } onClearUp: { object in
                                            onCancel(object)
                                        }
                                                .mapOutput { output in
                                                    [(req, output)]
                                                }

                                        var copy = machines.map
                                        copy[req] = machine

                                        return (MapOfMachines(copy), [], false)
                                    }
                                case .cancel(let req):
                                    if machines.map[req] != nil {
                                        var copy = machines.map
                                        copy.removeValue(forKey: req)

                                        return (MapOfMachines(copy), [], false)
                                    } else {
                                        // ignore
                                        return (machines, [], false)
                                    }
                                }
                            case .int(let value):
                                let (req, res) = value
                                return (machines, [.ext((req, res))], false)
                            }
                        }
                )
        )

        let machine2: Machine<IdEvent<TransformerOutput<TriggerReason, CancelReason, Req>>, IdEvent<TransformerInput<TriggerReason, CancelReason, Res>>> = Machine<IdEvent<TransformerOutput<TriggerReason, CancelReason, Req>>, IdEvent<TransformerInput<TriggerReason, CancelReason, Res>>>(
                FeatureTransition(
                        Outline.classic([TransformerId: Req]()) { state, trigger in
                                    switch trigger {
                                    case .ext(let input):
                                        let tag1 = input.id
                                        let data = input.data

                                        switch data {
                                        case .willTrigger(let tag2, let reason, let isTriggerOnMain, let request):
                                            let id = TransformerId(tag1: tag1, tag2: tag2)

                                            if state[id] != nil {
                                                // do nothing
                                                return (state, effects: [])
                                            } else {
                                                var copy = state
                                                copy[id] = request

                                                let effects: [FeatureEvent<ExecuteInput<Req>, IdEvent<TransformerInput<TriggerReason, CancelReason, Res>>>]
                                                if state.values.contains(request) {
                                                    effects = [.ext(IdEvent(id: tag1, data: .didTrigger(tag2, reason)))]
                                                } else {
                                                    effects = [.ext(IdEvent(id: tag1, data: .didTrigger(tag2, reason))), .int(.trigger(isTriggerOnMain, request))]
                                                }

                                                return (copy, effects: effects)
                                            }
                                        case .willCancel(let tag2, let reason):
                                            let id = TransformerId(tag1: tag1, tag2: tag2)

                                            if let request = state[id] {
                                                var copy = state
                                                copy[id] = nil

                                                let effects: [FeatureEvent<ExecuteInput<Req>, IdEvent<TransformerInput<TriggerReason, CancelReason, Res>>>]
                                                if copy.values.contains(request) {
                                                    effects = [.ext(IdEvent(id: tag1, data: .didCancel(tag2, reason)))]
                                                } else {
                                                    effects = [.ext(IdEvent(id: tag1, data: .didCancel(tag2, reason))), .int(.cancel(request))]
                                                }

                                                return (copy, effects: effects)
                                            } else {
                                                // do nothing
                                                return (state, effects: [])
                                            }
                                        }

                                    case .int(let (req, res)):
                                        let effects = state.flatMap { key, _req -> [FeatureEvent<ExecuteInput<Req>, IdEvent<TransformerInput<TriggerReason, CancelReason, Res>>>] in
                                            if _req == req {
                                                return [.ext(IdEvent(id: key.tag1, data: .didEmit(key.tag2, res)))]
                                            } else {
                                                return []
                                            }
                                        }

                                        return (state, effects: effects)
                                    }
                                }
                                .asFeature(SetOfMachines(machine1))
                )
        )


        let machine3: Machine<IdEvent<IntEffect>, IdEvent<IntTrigger>> = Machine<IdEvent<IntEffect>, IdEvent<IntTrigger>>(
                FeatureTransition(
                        Outline.classic(initial()) { state, trigger in
                                    switch trigger {
                                    case .ext(let event):
                                        let id = event.id
                                        let data = event.data
                                        
                                        let (newState, mapped) = mapReq(state, data)

                                        if let mapped {
                                            switch mapped {
                                            case .first(let data):
                                                return (newState, [.int(IdEvent(id: id, data: data))])
                                            case .second(let data):
                                                return (newState, [.ext(IdEvent(id: id, data: data))])
                                            }
                                        } else {
                                            return (newState, [])
                                        }
                                    case .int(let event):
                                        let id = event.id
                                        let data = event.data

                                        let (newState, mapped) = mapRes(state, data)

                                        if let mapped {
                                            switch mapped {
                                            case .first(let data):
                                                return (newState, [.ext(IdEvent(id: id, data: data))])
                                            case .second(let data):
                                                return (newState, [.int(IdEvent(id: id, data: data))])
                                            }
                                        } else {
                                            return (newState, [])
                                        }
                                    }
                                }
                                .asFeature(SetOfMachines(machine2))
                )
        )

        let machine4: Machine<IdEvent<Input>, IdEvent<Output>> = Machine<IdEvent<Input>, IdEvent<Output>>(
                FeatureTransition(
                        Outline.merge(Set(
                                        outlines.map {
                                            Outline.dynamic($0)
                                            
                                        }
                                ))
                                .asFeature(SetOfMachines(machine3))
                )
        )

        return machine4
    }
    
    
    private struct MapOfMachines<Key: Hashable, Trigger, Effect>: FeatureMachines {

        let map: [Key: Machine<Effect, Trigger>]

        init(_ map: [Key: Machine<Effect, Trigger>]) {
            self.map = map
        }

        var machines: Set<Machine<Effect, Trigger>> {
            Set(map.values)
        }
    }

    private enum ExecuteInput<Req: Equatable> {
        case trigger(Bool, Req)
        case cancel(Req)

        var request: Req {
            switch self {
            case .trigger(_, let req),
                 .cancel(let req):
                return req
            }
        }

        var isTrigger: Bool {
            switch self {
            case .trigger:
                return true
            case .cancel:
                return false
            }
        }

        var isCancel: Bool {
            !isTrigger
        }
    }
    
    private enum ExecuteOutput<Req: Equatable, Res> {
        case didTrigger(Req)
        case didCancel(Req)
        case didEmit(Req, Res)
    }
    
    private struct TransformerId: Hashable {
        let tag1: String
        let tag2: String
    }
}
