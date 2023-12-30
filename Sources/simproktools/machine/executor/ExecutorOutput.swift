////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 04.12.2023.
////
//
//
//public enum ExecutorOutput<Id: Hashable, Data>: Identifiable {
//    case didLaunchSucceed(id: Id)
//    case didLaunchFail(id: Id, error: Error)
//    
//    case didReceive(id: Id, data: Data, isLast: Bool)
//    
//    case didCancel(id: Id)
//    
//    public var id: Id {
//        switch self {
//        case .didLaunchSucceed(let id),
//                .didLaunchFail(let id, _),
//                .didReceive(let id, _, _),
//                .didCancel(let id):
//            id
//        }
//    }
//}
