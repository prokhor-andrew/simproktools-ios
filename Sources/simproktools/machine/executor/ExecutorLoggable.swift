////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 06.12.2023.
////
//
//import simprokmachine
//
//
//public enum ExecutorLoggable<Id: Hashable>: Loggable, Identifiable, Hashable, CustomStringConvertible {
//    case guardedLaunch(id: Id)
//    case guardedCancel(id: Id)
//    case guardedUpdate(id: Id)
//    
//    public var id: Id {
//        switch self {
//        case .guardedLaunch(let id),
//                .guardedCancel(let id),
//                .guardedUpdate(let id):
//            id
//        }
//    }
//    
//    public var description: String {
//        switch self {
//        case .guardedLaunch:
//            "guarded event=launch _ id=\(id) _ reason=already launched"
//        case .guardedCancel:
//            "guarded event=cancel _ id=\(id) _ reason=subscription missing"
//        case .guardedUpdate:
//            "guarded event=update _ id=\(id) _ reason=subscription missing"
//        }
//    }
//}
