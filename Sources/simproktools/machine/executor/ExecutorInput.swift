//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 04.12.2023.
//


public enum ExecutorInput<Id: Hashable, Payload>: Identifiable {
    case launch(id: Id, payload: Payload)
    case cancel(id: Id)
    case update(id: Id, payload: Payload)
    case config(id: Id, payload: Payload)
    
    
    public var id: Id {
        switch self {
        case .launch(let id, _),
                .cancel(let id),
                .update(let id, _),
                .config(let id, _):
            id
        }
    }
}


extension ExecutorInput: Equatable where Payload: Equatable { }

extension ExecutorInput: Hashable where Payload: Hashable { }
