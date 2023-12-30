////
////  File.swift
////  
////
////  Created by Andriy Prokhorenko on 04.12.2023.
////
//
//
//public enum ExecutorInput<Id: Hashable, Payload>: Identifiable {
//    case launch(id: Id, payload: Payload)
//    case cancel(id: Id)
//    
//    
//    public var id: Id {
//        switch self {
//        case .launch(let id, _),
//                .cancel(let id):
//            id
//        }
//    }
//}
//
//
//extension ExecutorInput: Equatable where Payload: Equatable { }
//
//extension ExecutorInput: Hashable where Payload: Hashable { }
