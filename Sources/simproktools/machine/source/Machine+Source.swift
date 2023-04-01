//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//

import simprokmachine
import simprokstate


public extension Machine {

    static func source<
        IntTrigger, IntEffect, ExtTrigger, ExtEffect, State, Holder: AnyObject, Req: Hashable, Res, LaunchReason, CancelReason
    >(
        typeIntTrigger : IntTrigger.Type,
        typeIntEffect : IntEffect.Type,
        typeExtTrigger : ExtTrigger.Type,
        typeExtEffect : ExtEffect.Type,
        typeRequest : Req.Type,
        typeResponse : Res.Type,
        typeLaunchReason : LaunchReason.Type,
        typeCancelReason : CancelReason.Type,
        
        initialState: Supplier<State>,
        mapReq: @escaping BiMapper<
            State,
            IntEffect,
            (
                State,
                FeatureEvent<
                    TransformOutput<LaunchReason, CancelReason, Req>,
                    OutlineFlexibleEvent<IntTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>
                >?
            )
        >,
        mapRes: @escaping BiMapper<
            State,
            TransformInput<LaunchReason, CancelReason, Res>,
            (
                State,
                FeatureEvent<
                    TransformOutput<LaunchReason, CancelReason, Req>,
                    OutlineFlexibleEvent<IntTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>
                >?
            )
        >,
        holder: @escaping Supplier<Holder>,
        onLaunch: @escaping TriHandler<Holder, Req, Handler<Res>>,
        onCancel: @escaping Handler<Holder>
    ) -> Machine<Input, Output> where
    Input == IdData<String, OutlineFlexibleEvent<ExtTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>,
    Output == IdData<String, ExtEffect>
    {

        let machine1: Machine<ExecuteInput<Req>, (Req, Res)> = Machine<ExecuteInput<Req>, (Req, Res)>(
                FeatureTransition<(Req, Res), Void, ExecuteInput<Req>, (Req, Res)>(
                        Feature.classic(MapOfMachines([:])) { machines, trigger in
                            switch trigger {
                            case .ext(let value):
                                switch value {
                                case .launch(let isLaunchOnMain, let req):
                                    if machines.map[req] != nil {
                                        // ignore
                                        return (machines, [], false)
                                    } else {
                                        let machine: Machine<Void, (Req, Res)> = Machine<Void, Res>(holder(), isProcessOnMain: isLaunchOnMain) { object, input, callback in
                                            if input == nil {
                                                // do here
                                                onLaunch(object, req, callback)
                                            }
                                        } onClearUp: { object in
                                            onCancel(object)
                                        }.mapOutput { output in
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

        let machine2: Machine<IdData<String, TransformOutput<LaunchReason, CancelReason, Req>>, IdData<String, TransformInput<LaunchReason, CancelReason, Res>>> = Machine<IdData<String, TransformOutput<LaunchReason, CancelReason, Req>>, IdData<String, TransformInput<LaunchReason, CancelReason, Res>>>(
                FeatureTransition(
                        Outline.classic([TransformerId: Req]()) { state, trigger in
                                    switch trigger {
                                    case .ext(let input):
                                        let tag1 = input.id
                                        let data = input.data

                                        switch data {
                                        case .willLaunch(let tag2, let reason, let isLaunchOnMain, let request):
                                            let id = TransformerId(tag1: tag1, tag2: tag2)

                                            if state[id] != nil {
                                                // do nothing
                                                return (state, effects: [])
                                            } else {
                                                var copy = state
                                                copy[id] = request

                                                let effects: [FeatureEvent<ExecuteInput<Req>, IdData<String, TransformInput<LaunchReason, CancelReason, Res>>>]
                                                if state.values.contains(request) {
                                                    effects = [.ext(IdData(id: tag1, data: .didLaunch(tag2, reason)))]
                                                } else {
                                                    effects = [.ext(IdData(id: tag1, data: .didLaunch(tag2, reason))), .int(.launch(isLaunchOnMain, request))]
                                                }

                                                return (copy, effects: effects)
                                            }
                                        case .willCancel(let tag2, let reason):
                                            let id = TransformerId(tag1: tag1, tag2: tag2)

                                            if let request = state[id] {
                                                var copy = state
                                                copy[id] = nil

                                                let effects: [FeatureEvent<ExecuteInput<Req>, IdData<String, TransformInput<LaunchReason, CancelReason, Res>>>]
                                                if copy.values.contains(request) {
                                                    effects = [.ext(IdData(id: tag1, data: .didCancel(tag2, reason)))]
                                                } else {
                                                    effects = [.ext(IdData(id: tag1, data: .didCancel(tag2, reason))), .int(.cancel(request))]
                                                }

                                                return (copy, effects: effects)
                                            } else {
                                                // do nothing
                                                return (state, effects: [])
                                            }
                                        }

                                    case .int(let (req, res)):
                                        let effects = state.flatMap { key, _req -> [FeatureEvent<ExecuteInput<Req>, IdData<String, TransformInput<LaunchReason, CancelReason, Res>>>] in
                                            if _req == req {
                                                return [.ext(IdData(id: key.tag1, data: .didEmit(key.tag2, res)))]
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


        let machine3: Machine<IdData<String, IntEffect>, IdData<String, OutlineFlexibleEvent<IntTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>> = Machine<IdData<String, IntEffect>, IdData<String, OutlineFlexibleEvent<IntTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>>(
                FeatureTransition(
                        Outline.classic(initialState()) { state, trigger in
                                    switch trigger {
                                    case .ext(let event):
                                        let id = event.id
                                        let data = event.data
                                        let (newState, mapped) = mapReq(state, data)

                                        if let mapped {
                                            switch mapped {
                                            case .int(let data):
                                                return (newState, [.int(IdData(id: id, data: data))])
                                            case .ext(let data):
                                                return (newState, [.ext(IdData(id: id, data: data))])
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
                                            case .ext(let data):
                                                return (newState, [.ext(IdData(id: id, data: data))])
                                            case .int(let data):
                                                return (newState, [.int(IdData(id: id, data: data))])
                                            }
                                        } else {
                                            return (newState, [])
                                        }
                                    }
                                }
                                .asFeature(SetOfMachines(machine2))
                )
        )

        
        let machine4: Machine<IdData<String, OutlineFlexibleEvent<ExtTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>, IdData<String, ExtEffect>> =
            Machine<IdData<String, OutlineFlexibleEvent<ExtTrigger, IntTrigger, IntEffect, ExtTrigger, ExtEffect>>, IdData<String, ExtEffect>>(
                FeatureTransition(
                    Outline.flexible(
                        typeId: String.self,
                        typeInternalTrigger: IntTrigger.self,
                        typeInternalEffect: IntEffect.self,
                        typeExternalTrigger: ExtTrigger.self,
                        typeExternalEffect: ExtEffect.self
                    ).asFeature(SetOfMachines(machine3))
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
        case launch(Bool, Req)
        case cancel(Req)

        var request: Req {
            switch self {
            case .launch(_, let req),
                 .cancel(let req):
                return req
            }
        }
    }

    private enum ExecuteOutput<Req: Equatable, Res> {
        case didLaunch(Req)
        case didCancel(Req)
        case didEmit(Req, Res)
    }

    private struct TransformerId: Hashable {
        let tag1: String
        let tag2: String
    }
}
