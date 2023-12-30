////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 07.12.2023.
////
//
//import simprokstate
//
//
//public extension Outline {
//    
//    static func executorStorage<IntId, ExtId, Payload, Data>() -> Outline<IntTrigger, IntEffect, ExtTrigger, ExtEffect> where
//    IntTrigger == ExecutorOutput<IntId, Data>,
//    IntEffect == ExecutorInput<IntId, Payload>,
//    ExtTrigger == ExecutorInput<ExtId, (id: IntId, payload: Payload)>,
//    ExtEffect == ExecutorOutput<ExtId, (id: IntId, data: Data)> {
//        Outline.classic(
//            (
//                Dictionary<ExtId, IntId>(),
//                Dictionary<IntId, (Set<ExtId>, Bool)>()
//            )
//        ) { extras, state, trigger in
//
//            let (dict1, dict2) = state
//
//            switch trigger {
//            case .ext(let event):
//                switch event {
//                case .launch(let id, let payload):
//
//                    if dict1[id] != nil {
//                        return (state, [])
//                    } else {
//                        if let (set, isLaunched) = dict2[payload.id] {
//                            var copyDict1 = dict1
//                            copyDict1[id] = payload.id
//
//                            var copySet = set
//                            copySet.insert(id)
//
//                            var copyDict2 = dict2
//                            copyDict2[payload.id] = (copySet, isLaunched)
//
//                            return ((copyDict1, copyDict2), isLaunched ? [.ext(.didLaunchSucceed(id: id))] : [])
//                        } else {
//                            var copyDict1 = dict1
//                            var copyDict2 = dict2
//
//                            copyDict1[id] = payload.id
//                            copyDict2[payload.id] = ([id], false)
//
//                            return ((copyDict1, copyDict2), [.int(.launch(id: payload.id, payload: payload.payload))])
//                        }
//                    }
//                case .cancel(let id):
//                    if let intId = dict1[id] {
//                        var copyDict1 = dict1
//                        copyDict1[id] = nil
//
//                        if let (set, isLaunched) = dict2[intId] {
//                            var copySet = set
//                            copySet.remove(id)
//
//                            var copyDict2 = dict2
//
//                            if copySet.isEmpty {
//                                copyDict2[intId] = nil
//                            } else {
//                                copyDict2[intId] = (copySet, isLaunched)
//                            }
//
//                            return (
//                                (copyDict1, copyDict2),
//                                copySet.isEmpty ? [.ext(.didCancel(id: id)), .int(.cancel(id: intId))] : [.ext(.didCancel(id: id))]
//                            )
//                        } else {
//                            return ((copyDict1, dict2), [.ext(.didCancel(id: id))])
//                        }
//                    } else {
//                        return (state, [])
//                    }
//                }
//            case .int(let event):
//                switch event {
//                case .didReceive(let intId, let data, let isLast):
//                    if let (set, _) = dict2[intId] {
//                        if isLast {
//                            var copyDict1 = dict1
//
//                            for id in set {
//                                copyDict1[id] = nil
//                            }
//
//                            var copyDict2 = dict2
//
//                            copyDict2[intId] = nil
//
//                            return ((copyDict1, copyDict2), set.map { id in
//                                .ext(
//                                    .didReceive(id: id, data: (intId, data), isLast: isLast)
//                                )
//                            })
//                        } else {
//                            return (state, set.map { id in
//                                .ext(
//                                    .didReceive(id: id, data: (intId, data), isLast: isLast)
//                                )
//                            })
//                        }
//
//                    } else {
//                        return (state, [])
//                    }
//                case .didLaunchSucceed(let intId):
//                    if let (set, _) = dict2[intId] {
//                        var copyDict2 = dict2
//                        copyDict2[intId] = (set, true)
//
//                        return ((dict1, copyDict2), set.map { id in
//                            .ext(.didLaunchSucceed(id: id))
//                        })
//                    } else {
//                        return (state, [])
//                    }
//                case .didLaunchFail(let intId, let error):
//                    if let (set, _) = dict2[intId] {
//                        var copyDict1 = dict1
//
//                        for id in set {
//                            copyDict1[id] = nil
//                        }
//
//
//                        var copyDict2 = dict2
//
//                        copyDict2[intId] = nil
//
//
//                        return ((copyDict1, copyDict2), set.map { id in
//                            .ext(.didLaunchFail(id: id, error: error))
//                        })
//                    } else {
//                        return (state, [])
//                    }
//                case .didCancel:
//                    // do nothing
//                    return (state, [])
//                }
//            }
//        }
//    }
//}
//
